import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../../shared/models/lab_model.dart';
import '../../../shared/models/test_model.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/constants/app_constants.dart';

class SearchController extends GetxController {
  final RxList<LabModel> _searchResults = <LabModel>[].obs;
  final RxList<TestModel> _testResults = <TestModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _searchQuery = ''.obs;
  final RxString _selectedCategory = ''.obs;
  final RxString _sortBy = 'distance'.obs;
  final Rx<Position?> _currentLocation = Rx<Position?>(null);

  List<LabModel> get searchResults => _searchResults;
  List<TestModel> get testResults => _testResults;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  String get selectedCategory => _selectedCategory.value;
  String get sortBy => _sortBy.value;

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
    
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args['query'] != null) {
        _searchQuery.value = args['query'];
        searchLabs(args['query']);
      }
      if (args['category'] != null) {
        _selectedCategory.value = args['category'];
        searchByCategory(args['category']);
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      _currentLocation.value = position;
    }
  }

  Future<void> searchLabs(String query) async {
    if (query.isEmpty) return;
    
    _isLoading.value = true;
    _searchQuery.value = query;
    
    try {
      final labsQuery = await FirebaseService.firestore
          .collection(AppConstants.labsCollection)
          .where('isActive', isEqualTo: true)
          .where('isVerified', isEqualTo: true)
          .get();

      final testsQuery = await FirebaseService.firestore
          .collection(AppConstants.testsCollection)
          .where('isAvailable', isEqualTo: true)
          .get();

      final labs = labsQuery.docs
          .map((doc) => LabModel.fromFirestore(doc))
          .where((lab) => 
              lab.name.toLowerCase().contains(query.toLowerCase()) ||
              lab.description.toLowerCase().contains(query.toLowerCase()))
          .toList();

      final tests = testsQuery.docs
          .map((doc) => TestModel.fromFirestore(doc))
          .where((test) => 
              test.name.toLowerCase().contains(query.toLowerCase()) ||
              test.description.toLowerCase().contains(query.toLowerCase()))
          .toList();

      _searchResults.value = labs;
      _testResults.value = tests;
      _sortResults();
    } catch (e) {
      Get.snackbar('Error', 'Failed to search labs');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> searchByCategory(String category) async {
    _isLoading.value = true;
    _selectedCategory.value = category;
    
    try {
      final testsQuery = await FirebaseService.firestore
          .collection(AppConstants.testsCollection)
          .where('category', isEqualTo: category)
          .where('isAvailable', isEqualTo: true)
          .get();

      final tests = testsQuery.docs
          .map((doc) => TestModel.fromFirestore(doc))
          .toList();

      final labIds = tests.map((test) => test.labId).toSet().toList();
      
      if (labIds.isNotEmpty) {
        final labsQuery = await FirebaseService.firestore
            .collection(AppConstants.labsCollection)
            .where('isActive', isEqualTo: true)
            .where('isVerified', isEqualTo: true)
            .get();

        final labs = labsQuery.docs
            .map((doc) => LabModel.fromFirestore(doc))
            .where((lab) => labIds.contains(lab.id))
            .toList();

        _searchResults.value = labs;
      }
      
      _testResults.value = tests;
      _sortResults();
    } catch (e) {
      Get.snackbar('Error', 'Failed to search by category');
    } finally {
      _isLoading.value = false;
    }
  }

  void setSortBy(String sortBy) {
    _sortBy.value = sortBy;
    _sortResults();
  }

  void _sortResults() {
    if (_currentLocation.value == null) return;

    switch (_sortBy.value) {
      case 'distance':
        _searchResults.sort((a, b) {
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
        break;
      case 'rating':
        _searchResults.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'price':
        _testResults.sort((a, b) => a.price.compareTo(b.price));
        break;
    }
  }

  void clearSearch() {
    _searchQuery.value = '';
    _selectedCategory.value = '';
    _searchResults.clear();
    _testResults.clear();
  }
}