import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> logEvent(String name, Map<String, Object>? parameters) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  static Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  static Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  static Future<void> logBooking({
    required String testId,
    required String labId,
    required double amount,
  }) async {
    await _analytics.logEvent(
      name: 'booking_created',
      parameters: {
        'test_id': testId,
        'lab_id': labId,
        'amount': amount,
        'currency': 'INR',
      },
    );
  }

  static Future<void> logPayment({
    required String paymentMethod,
    required double amount,
  }) async {
    await _analytics.logEvent(
      name: 'payment_completed',
      parameters: {
        'payment_method': paymentMethod,
        'amount': amount,
        'currency': 'INR',
      },
    );
  }

  static Future<void> logSearch(String searchTerm) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  static Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }

  static Future<void> setUserProperty(String name, String value) async {
    await _analytics.setUserProperty(name: name, value: value);
  }
}