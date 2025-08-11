import 'package:get/get.dart';
import '../../features/auth/views/splash_view.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/auth/views/signup_view.dart';
import '../../features/auth/views/forgot_password_view.dart';
import '../../shared/widgets/bottom_nav_wrapper.dart';
import '../../features/booking/views/booking_view.dart';
import '../../features/profile/views/settings_view.dart';
import '../../features/lab/views/lab_dashboard_view.dart';
import '../../features/admin/views/admin_dashboard_view.dart';
import '../bindings/initial_binding.dart';

class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String booking = '/booking';
  static const String settings = '/settings';
  static const String labDashboard = '/lab-dashboard';
  static const String adminDashboard = '/admin-dashboard';

  static List<GetPage> get pages => [
    GetPage(
      name: initial,
      page: () => const SplashView(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: login,
      page: () => const LoginView(),
    ),
    GetPage(
      name: signup,
      page: () => const SignupView(),
    ),
    GetPage(
      name: forgotPassword,
      page: () => const ForgotPasswordView(),
    ),
    GetPage(
      name: home,
      page: () => const BottomNavWrapper(),
    ),
    GetPage(
      name: booking,
      page: () => const BookingView(),
    ),
    GetPage(
      name: settings,
      page: () => const SettingsView(),
    ),
    GetPage(
      name: labDashboard,
      page: () => const LabDashboardView(),
    ),
    GetPage(
      name: adminDashboard,
      page: () => const AdminDashboardView(),
    ),
  ];
}