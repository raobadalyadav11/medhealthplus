import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../../shared/models/lab_model.dart';
import '../../../shared/models/test_model.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/constants/app_constants.dart';

class HomeController extends GetxController {
  final RxList<LabModel> _nearbyLabs = <LabModel>[].obs;
  final RxList<TestModel> _popularTests = <TestModel>[].obs;
  final RxBool _isLoading = false.obs;
  final Rx<Position?> _currentLocation = Rx<Position?>(null);
  final RxString _selectedCategory = ''.obs;

  List<LabModel> get nearbyLabs => _nearbyLabs;
  List<TestModel> get popularTests => _popularTests;
  bool get isLoading => _isLoading.value;
  Position? get currentLocation => _currentLocation.value;
  String get selectedCategory => _selectedCategory.value;

  final List<Map<String, dynamic>> testCategories = [
    {
      'name': 'X-Ray',
      'icon': 'assets/icons/xray.png',
      'category': AppConstants.xrayCategory,
    },
    {
      'name': 'Ultrasound',
      'icon': 'assets/icons/ultrasound.png',
      'category': AppConstants.ultrasoundCategory,
    },
    {
      'name': 'Blood Test',
      'icon': 'assets/icons/blood_test.png',
      'category': AppConstants.bloodTestCategory,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeHome();
  }

  Future<void> _initializeHome() async {
    _isLoading.value = true;
    await _getCurrentLocation();
    await _loadNearbyLabs();
    await _loadPopularTests();
    _isLoading.value = false;
  }

  Future<void> _getCurrentLocation() async {
    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      _currentLocation.value = position;
    }
  }

  Future<void> _loadNearbyLabs() async {
    try {
      final querySnapshot = await FirebaseService.firestore
          .collection(AppConstants.labsCollection)
          .where('isActive', isEqualTo: true)
          .where('isVerified', isEqualTo: true)
          .limit(10)
          .get();

      final labs = querySnapshot.docs
          .map((doc) => LabModel.fromFirestore(doc))
          .toList();

      if (_currentLocation.value != null) {
        // Sort by distance
        labs.sort((a, b) {
          final distanceA = LocationService.calculateDistance(
            _currentLocation.value!.latitude,
            _currentLocation.value!.longitude,
            a.latitude,
            a.longitude,
          );
          final distanceB = LocationService.calculateDistance(
            _currentLocation.value!.latitude,
            _currentLocation.value!.longitude,
            b.latitude,
            b.longitude,
          );
          return distanceA.compareTo(distanceB);
        });
      }

      _nearbyLabs.value = labs;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load nearby labs');
    }
  }

  Future<void> _loadPopularTests() async {
    try {
      final querySnapshot = await FirebaseService.firestore
          .collection(AppConstants.testsCollection)
          .where('isAvailable', isEqualTo: true)
          .orderBy('price')
          .limit(10)
          .get();

      _popularTests.value = querySnapshot.docs
          .map((doc) => TestModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load popular tests');
    }
  }

  void selectCategory(String category) {
    _selectedCategory.value = category;
    Get.toNamed('/search', arguments: {'category': category});
  }

  void searchTests(String query) {
    Get.toNamed('/search', arguments: {'query': query});
  }

  @override
  Future<void> refresh() async {
    await _initializeHome();
  }
}