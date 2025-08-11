import 'package:get/get.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/models/lab_model.dart';
import '../../../shared/models/booking_model.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/constants/app_constants.dart';

class AdminController extends GetxController {
  final RxList<UserModel> _users = <UserModel>[].obs;
  final RxList<LabModel> _labs = <LabModel>[].obs;
  final RxList<BookingModel> _bookings = <BookingModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxDouble _totalRevenue = 0.0.obs;
  final RxInt _totalBookings = 0.obs;

  List<UserModel> get users => _users;
  List<LabModel> get labs => _labs;
  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading.value;
  double get totalRevenue => _totalRevenue.value;
  int get totalBookings => _totalBookings.value;

  @override
  void onInit() {
    super.onInit();
    loadAdminData();
  }

  Future<void> loadAdminData() async {
    _isLoading.value = true;
    try {
      await Future.wait([
        _loadUsers(),
        _loadLabs(),
        _loadBookings(),
      ]);
      _calculateStats();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadUsers() async {
    final querySnapshot = await FirebaseService.firestore
        .collection(AppConstants.usersCollection)
        .orderBy('createdAt', descending: true)
        .get();

    _users.value = querySnapshot.docs
        .map((doc) => UserModel.fromFirestore(doc))
        .toList();
  }

  Future<void> _loadLabs() async {
    final querySnapshot = await FirebaseService.firestore
        .collection(AppConstants.labsCollection)
        .orderBy('createdAt', descending: true)
        .get();

    _labs.value = querySnapshot.docs
        .map((doc) => LabModel.fromFirestore(doc))
        .toList();
  }

  Future<void> _loadBookings() async {
    final querySnapshot = await FirebaseService.firestore
        .collection(AppConstants.bookingsCollection)
        .orderBy('createdAt', descending: true)
        .get();

    _bookings.value = querySnapshot.docs
        .map((doc) => BookingModel.fromFirestore(doc))
        .toList();
  }

  void _calculateStats() {
    _totalBookings.value = _bookings.length;
    _totalRevenue.value = _bookings
        .where((booking) => booking.paymentStatus == 'completed')
        .fold(0.0, (sum, booking) => sum + (booking.finalAmount * AppConstants.commissionRate));
  }

  Future<void> verifyLab(String labId) async {
    try {
      await FirebaseService.firestore
          .collection(AppConstants.labsCollection)
          .doc(labId)
          .update({
        'isVerified': true,
        'updatedAt': DateTime.now(),
      });
      
      await _loadLabs();
      Get.snackbar('Success', 'Lab verified successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to verify lab');
    }
  }

  Future<void> suspendUser(String userId) async {
    try {
      await FirebaseService.firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({
        'isActive': false,
        'updatedAt': DateTime.now(),
      });
      
      await _loadUsers();
      Get.snackbar('Success', 'User suspended successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to suspend user');
    }
  }

  List<LabModel> get pendingLabs => 
      _labs.where((lab) => !lab.isVerified).toList();

  List<BookingModel> get recentBookings => 
      _bookings.take(10).toList();

  Map<String, int> get bookingsByStatus {
    final Map<String, int> stats = {};
    for (final booking in _bookings) {
      stats[booking.bookingStatus] = (stats[booking.bookingStatus] ?? 0) + 1;
    }
    return stats;
  }
}