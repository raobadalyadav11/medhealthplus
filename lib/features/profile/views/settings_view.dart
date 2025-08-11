import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../controllers/profile_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Settings
          _buildSectionHeader('Account Settings'),
          _buildSettingsTile(
            icon: Icons.person,
            title: 'Edit Profile',
            subtitle: 'Update your personal information',
            onTap: () => Get.toNamed('/edit-profile'),
          ),
          _buildSettingsTile(
            icon: Icons.lock,
            title: 'Change Password',
            subtitle: 'Update your account password',
            onTap: () => Get.toNamed('/change-password'),
          ),

          const SizedBox(height: 24),

          // App Settings
          _buildSectionHeader('App Settings'),
          Obx(() => _buildSettingsTile(
                icon: Icons.language,
                title: 'Language',
                subtitle:
                    controller.selectedLanguage == 'en' ? 'English' : 'हिंदी',
                onTap: () => _showLanguageDialog(context, controller),
              )),
          Obx(() => _buildSettingsTile(
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle:
                    controller.notificationsEnabled ? 'Enabled' : 'Disabled',
                trailing: Switch(
                  value: controller.notificationsEnabled,
                  onChanged: controller.toggleNotifications,
                ),
              )),
          _buildSettingsTile(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            subtitle: 'Coming soon',
            trailing: const Switch(
              value: false,
              onChanged: null,
            ),
          ),

          const SizedBox(height: 24),

          // Support
          _buildSectionHeader('Support'),
          _buildSettingsTile(
            icon: Icons.help,
            title: 'Help & Support',
            subtitle: 'Get help with your account',
            onTap: () => Get.toNamed('/help'),
          ),
          _buildSettingsTile(
            icon: Icons.feedback,
            title: 'Send Feedback',
            subtitle: 'Help us improve the app',
            onTap: () => _showFeedbackDialog(context),
          ),
          _buildSettingsTile(
            icon: Icons.star_rate,
            title: 'Rate App',
            subtitle: 'Rate us on the app store',
            onTap: () => _rateApp(),
          ),

          const SizedBox(height: 24),

          // Legal
          _buildSectionHeader('Legal'),
          _buildSettingsTile(
            icon: Icons.description,
            title: 'Terms & Conditions',
            onTap: () => Get.toNamed('/terms'),
          ),
          _buildSettingsTile(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            onTap: () => Get.toNamed('/privacy'),
          ),
          _buildSettingsTile(
            icon: Icons.info,
            title: 'About',
            subtitle: 'Version 1.0.0',
            onTap: () => Get.toNamed('/about'),
          ),

          const SizedBox(height: 32),

          // Danger Zone
          _buildSectionHeader('Danger Zone', color: Colors.red),
          _buildSettingsTile(
            icon: Icons.delete_forever,
            title: 'Delete Account',
            subtitle: 'Permanently delete your account',
            titleColor: Colors.red,
            onTap: controller.deleteAccount,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color ?? Get.theme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Color? titleColor,
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
        leading: Icon(icon, color: titleColor ?? Get.theme.primaryColor),
        title: Text(
          title,
          style: TextStyle(color: titleColor),
        ),
        subtitle: subtitle != null ? Text(subtitle) : null,
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

  void _showFeedbackDialog(BuildContext context) {
    final feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Feedback'),
        content: TextField(
          controller: feedbackController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Tell us what you think...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.snackbar('Thank you!', 'Your feedback has been sent.');
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _rateApp() {
    Get.snackbar('Rate App', 'Redirecting to app store...');
  }
}
