import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/models/test_model.dart';
import '../../../shared/models/lab_model.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../features/auth/controllers/auth_controller.dart';

class BookingController extends GetxController {
  final RxList<BookingModel> _bookings = <BookingModel>[].obs;
  final RxBool _isLoading = false.obs;
  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(null);
  final RxString _selectedTimeSlot = ''.obs;
  final RxString _paymentMethod = 'online'.obs;
  final RxString _couponCode = ''.obs;
  final RxDouble _discountAmount = 0.0.obs;
  
  late Razorpay _razorpay;
  final _authController = Get.find<AuthController>();

  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading.value;
  DateTime? get selectedDate => _selectedDate.value;
  String get selectedTimeSlot => _selectedTimeSlot.value;
  String get paymentMethod => _paymentMethod.value;
  String get couponCode => _couponCode.value;
  double get discountAmount => _discountAmount.value;

  final List<String> timeSlots = [
    '09:00 AM', '09:30 AM', '10:00 AM', '10:30 AM',
    '11:00 AM', '11:30 AM', '12:00 PM', '12:30 PM',
    '02:00 PM', '02:30 PM', '03:00 PM', '03:30 PM',
    '04:00 PM', '04:30 PM', '05:00 PM', '05:30 PM',
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeRazorpay();
    loadBookings();
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> loadBookings() async {
    if (_authController.user == null) return;
    
    _isLoading.value = true;
    try {
      final querySnapshot = await FirebaseService.firestore
          .collection(AppConstants.bookingsCollection)
          .where('patientId', isEqualTo: _authController.user!.uid)
          .orderBy('createdAt', descending: true)
          .get();

      _bookings.value = querySnapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load bookings');
    } finally {
      _isLoading.value = false;
    }
  }

  void setSelectedDate(DateTime date) {
    _selectedDate.value = date;
  }

  void setSelectedTimeSlot(String timeSlot) {
    _selectedTimeSlot.value = timeSlot;
  }

  void setPaymentMethod(String method) {
    _paymentMethod.value = method;
  }

  Future<void> applyCoupon(String code) async {
    _couponCode.value = code;
    // Implement coupon validation logic here
    // For now, applying a fixed 10% discount
    _discountAmount.value = 50.0; // Fixed ₹50 discount
  }

  Future<void> bookTest({
    required TestModel test,
    required LabModel lab,
  }) async {
    if (_authController.user == null) {
      Get.snackbar('Error', 'Please login to book a test');
      return;
    }

    if (_selectedDate.value == null || _selectedTimeSlot.value.isEmpty) {
      Get.snackbar('Error', 'Please select date and time');
      return;
    }

    _isLoading.value = true;
    
    try {
      final finalAmount = test.price - _discountAmount.value;
      
      final booking = BookingModel(
        id: '',
        patientId: _authController.user!.uid,
        labId: lab.id,
        testId: test.id,
        bookingDate: _selectedDate.value!,
        timeSlot: _selectedTimeSlot.value,
        totalAmount: test.price,
        discountAmount: _discountAmount.value,
        finalAmount: finalAmount,
        paymentMethod: _paymentMethod.value,
        couponCode: _couponCode.value.isNotEmpty ? _couponCode.value : null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (_paymentMethod.value == 'online') {
        _initiateRazorpayPayment(booking, test, lab);
      } else {
        await _saveBooking(booking);
        Get.snackbar('Success', 'Booking confirmed! Pay at the center.');
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to book test');
    } finally {
      _isLoading.value = false;
    }
  }

  void _initiateRazorpayPayment(BookingModel booking, TestModel test, LabModel lab) {
    final options = {
      'key': AppConstants.razorpayKeyId,
      'amount': (booking.finalAmount * 100).toInt(), // Amount in paise
      'name': 'MedHealthPlus',
      'description': '${test.name} at ${lab.name}',
      'prefill': {
        'contact': _authController.userModel?.phone ?? '',
        'email': _authController.userModel?.email ?? '',
      },
      'theme': {
        'color': '#2E7D32',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      Get.snackbar('Error', 'Failed to open payment gateway');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Save booking with payment ID
    final booking = _createBookingFromPayment(response);
    await _saveBooking(booking);
    Get.snackbar('Success', 'Payment successful! Booking confirmed.');
    Get.offAllNamed('/home');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar('Payment Failed', response.message ?? 'Payment failed');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar('External Wallet', 'External wallet selected: ${response.walletName}');
  }

  BookingModel _createBookingFromPayment(PaymentSuccessResponse response) {
    // This would be populated from the current booking context
    return BookingModel(
      id: '',
      patientId: _authController.user!.uid,
      labId: '', // Set from context
      testId: '', // Set from context
      bookingDate: _selectedDate.value!,
      timeSlot: _selectedTimeSlot.value,
      totalAmount: 0, // Set from context
      discountAmount: _discountAmount.value,
      finalAmount: 0, // Set from context
      paymentMethod: 'online',
      paymentStatus: 'completed',
      razorpayPaymentId: response.paymentId,
      couponCode: _couponCode.value.isNotEmpty ? _couponCode.value : null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Future<void> _saveBooking(BookingModel booking) async {
    await FirebaseService.firestore
        .collection(AppConstants.bookingsCollection)
        .add(booking.toFirestore());
    
    await loadBookings();
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await FirebaseService.firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .update({
        'bookingStatus': AppConstants.cancelledStatus,
        'updatedAt': DateTime.now(),
      });
      
      await loadBookings();
      Get.snackbar('Success', 'Booking cancelled successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel booking');
    }
  }
}