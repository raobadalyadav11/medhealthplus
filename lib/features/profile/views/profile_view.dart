import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../controllers/profile_controller.dart';
import '../../../features/auth/controllers/auth_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final authController = Get.find<AuthController>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      authController.userModel?.name.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authController.userModel?.name ?? 'User',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          authController.userModel?.email ?? '',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          authController.userModel?.phone ?? '',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.toNamed('/edit-profile'),
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Menu Items
            _buildMenuItem(
              icon: Icons.history,
              title: l10n.bookingHistory,
              onTap: () => Get.toNamed('/booking-history'),
            ),
            _buildMenuItem(
              icon: Icons.file_download,
              title: l10n.viewReports,
              onTap: () => Get.toNamed('/reports'),
            ),
            _buildMenuItem(
              icon: Icons.settings,
              title: l10n.settings,
              onTap: () => Get.toNamed('/settings'),
            ),
            _buildMenuItem(
              icon: Icons.language,
              title: l10n.language,
              trailing: Obx(() => Text(
                controller.selectedLanguage == 'en' ? 'English' : 'हिंदी',
                style: TextStyle(color: Colors.grey[600]),
              )),
              onTap: () => _showLanguageDialog(context, controller),
            ),
            _buildMenuItem(
              icon: Icons.notifications,
              title: l10n.notifications,
              trailing: Obx(() => Switch(
                value: controller.notificationsEnabled,
                onChanged: controller.toggleNotifications,
              )),
            ),
            _buildMenuItem(
              icon: Icons.help,
              title: l10n.help,
              onTap: () => Get.toNamed('/help'),
            ),
            _buildMenuItem(
              icon: Icons.info,
              title: l10n.aboutUs,
              onTap: () => Get.toNamed('/about'),
            ),
            _buildMenuItem(
              icon: Icons.description,
              title: l10n.termsConditions,
              onTap: () => Get.toNamed('/terms'),
            ),
            _buildMenuItem(
              icon: Icons.privacy_tip,
              title: l10n.privacyPolicy,
              onTap: () => Get.toNamed('/privacy'),
            ),
            const SizedBox(height: 24),

            // Logout Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: controller.logout,
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.red[600],
                    ),
                    const SizedBox(width: 16),
                    Text(
                      l10n.logout,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Delete Account Button
            TextButton(
              onPressed: controller.deleteAccount,
              child: Text(
                'Delete Account',
                style: TextStyle(
                  color: Colors.red[400],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Get.theme.primaryColor),
        title: Text(title),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              leading: Radio<String>(
                value: 'en',
                groupValue: controller.selectedLanguage,
                onChanged: (value) {
                  Navigator.pop(context);
                  controller.changeLanguage(value!);
                },
              ),
            ),
            ListTile(
              title: const Text('हिंदी'),
              leading: Radio<String>(
                value: 'hi',
                groupValue: controller.selectedLanguage,
                onChanged: (value) {
                  Navigator.pop(context);
                  controller.changeLanguage(value!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}