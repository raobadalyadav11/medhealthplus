import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/constants/app_constants.dart';

class ProfileController extends GetxController {
  final RxString _selectedLanguage = 'en'.obs;
  final RxBool _notificationsEnabled = true.obs;
  final RxBool _isLoading = false.obs;
  
  final _authController = Get.find<AuthController>();

  String get selectedLanguage => _selectedLanguage.value;
  bool get notificationsEnabled => _notificationsEnabled.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedLanguage.value = prefs.getString('language') ?? 'en';
    _notificationsEnabled.value = prefs.getBool('notifications') ?? true;
  }

  Future<void> changeLanguage(String languageCode) async {
    _selectedLanguage.value = languageCode;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
    
    // Update user language preference in Firestore
    if (_authController.user != null) {
      await FirebaseService.firestore
          .collection(AppConstants.usersCollection)
          .doc(_authController.user!.uid)
          .update({'language': languageCode});
    }
    
    // Update app locale
    final locale = Locale(languageCode);
    Get.updateLocale(locale);
    
    Get.snackbar('Success', 'Language changed successfully');
  }

  Future<void> toggleNotifications(bool enabled) async {
    _notificationsEnabled.value = enabled;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', enabled);
    
    // Handle FCM token subscription/unsubscription
    if (enabled) {
      await FirebaseService.messaging.subscribeToTopic('all_users');
    } else {
      await FirebaseService.messaging.unsubscribeFromTopic('all_users');
    }
    
    Get.snackbar('Success', 
        enabled ? 'Notifications enabled' : 'Notifications disabled');
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
  }) async {
    if (_authController.user == null) return;
    
    _isLoading.value = true;
    
    try {
      await FirebaseService.firestore
          .collection(AppConstants.usersCollection)
          .doc(_authController.user!.uid)
          .update({
        'name': name,
        'phone': phone,
        'updatedAt': DateTime.now(),
      });
      
      await _authController.user!.updateDisplayName(name);
      
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      _isLoading.value = false;
    }
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _authController.signOut();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void deleteAccount() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _performAccountDeletion();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _performAccountDeletion() async {
    if (_authController.user == null) return;
    
    _isLoading.value = true;
    
    try {
      // Delete user data from Firestore
      await FirebaseService.firestore
          .collection(AppConstants.usersCollection)
          .doc(_authController.user!.uid)
          .delete();
      
      // Delete user account
      await _authController.user!.delete();
      
      Get.snackbar('Success', 'Account deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete account');
    } finally {
      _isLoading.value = false;
    }
  }
}