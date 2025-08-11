import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class CrashService {
  static void initialize() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      recordError(details.exception, details.stack);
    };
  }

  static void recordError(dynamic exception, StackTrace? stackTrace) {
    if (kDebugMode) {
      developer.log(
        'Error recorded',
        error: exception,
        stackTrace: stackTrace,
      );
    } else {
      // In production, send to crash reporting service
      // Firebase Crashlytics would be integrated here
    }
  }

  static void recordMessage(String message) {
    if (kDebugMode) {
      developer.log(message);
    }
  }
}