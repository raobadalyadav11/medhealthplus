import 'package:get/get.dart';
import '../../../shared/models/lab_model.dart';
import '../../../shared/models/test_model.dart';
import '../../../shared/models/booking_model.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../features/auth/controllers/auth_controller.dart';

class LabController extends GetxController {
  final RxList<TestModel> _labTests = <TestModel>[].obs;
  final RxList<BookingModel> _labBookings = <BookingModel>[].obs;
  final RxBool _isLoading = false.obs;
  final Rx<LabModel?> _currentLab = Rx<LabModel?>(null);
  
  final _authController = Get.find<AuthController>();

  List<TestModel> get labTests => _labTests;
  List<BookingModel> get labBookings => _labBookings;
  bool get isLoading => _isLoading.value;
  LabModel? get currentLab => _currentLab.value;

  @override
  void onInit() {
    super.onInit();
    loadLabData();
  }

  Future<void> loadLabData() async {
    if (_authController.user == null) return;
    
    _isLoading.value = true;
    try {
      await _loadCurrentLab();
      await _loadLabTests();
      await _loadLabBookings();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadCurrentLab() async {
    final querySnapshot = await FirebaseService.firestore
        .collection(AppConstants.labsCollection)
        .where('ownerId', isEqualTo: _authController.user!.uid)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      _currentLab.value = LabModel.fromFirestore(querySnapshot.docs.first);
    }
  }

  Future<void> _loadLabTests() async {
    if (_currentLab.value == null) return;

    final querySnapshot = await FirebaseService.firestore
        .collection(AppConstants.testsCollection)
        .where('labId', isEqualTo: _currentLab.value!.id)
        .get();

    _labTests.value = querySnapshot.docs
        .map((doc) => TestModel.fromFirestore(doc))
        .toList();
  }

  Future<void> _loadLabBookings() async {
    if (_currentLab.value == null) return;

    final querySnapshot = await FirebaseService.firestore
        .collection(AppConstants.bookingsCollection)
        .where('labId', isEqualTo: _currentLab.value!.id)
        .orderBy('createdAt', descending: true)
        .get();

    _labBookings.value = querySnapshot.docs
        .map((doc) => BookingModel.fromFirestore(doc))
        .toList();
  }

  Future<void> addTest(TestModel test) async {
    if (_currentLab.value == null) return;

    try {
      await FirebaseService.firestore
          .collection(AppConstants.testsCollection)
          .add(test.toFirestore());
      
      await _loadLabTests();
      Get.snackbar('Success', 'Test added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add test');
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await FirebaseService.firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .update({
        'bookingStatus': status,
        'updatedAt': DateTime.now(),
      });
      
      await _loadLabBookings();
      Get.snackbar('Success', 'Booking status updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update booking');
    }
  }

  Future<void> uploadReport(String bookingId, String reportUrl) async {
    try {
      await FirebaseService.firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .update({
        'reportUrl': reportUrl,
        'bookingStatus': AppConstants.completedStatus,
        'updatedAt': DateTime.now(),
      });
      
      await _loadLabBookings();
      Get.snackbar('Success', 'Report uploaded successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload report');
    }
  }
}