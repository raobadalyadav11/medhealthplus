# MedHealthPlus - Setup Instructions

## Overview
MedHealthPlus is a comprehensive diagnostic test booking application built with Flutter and Firebase, specifically designed for the Indian market with multilingual support (English/Hindi) and INR pricing.

## Features
- 🔐 Email-based authentication with Firebase Auth
- 🏥 Lab and test search with location-based results
- 📅 Calendar-based booking system
- 💳 Razorpay integration for online payments
- 🌍 Multilingual support (English/Hindi)
- 📱 Responsive design for mobile and web
- 🔔 Push notifications with Firebase Messaging
- 📊 Real-time data with Firestore
- 🗺️ Google Maps integration for location services

## Prerequisites
- Flutter SDK (>=3.1.0)
- Dart SDK
- Android Studio / VS Code
- Firebase project
- Razorpay account (for payments)
- Google Maps API key

## Setup Instructions

### 1. Clone and Install Dependencies
```bash
cd medhealthplus
flutter pub get
```

### 2. Firebase Setup
1. Create a new Firebase project at https://console.firebase.google.com
2. Enable the following services:
   - Authentication (Email/Password)
   - Firestore Database
   - Storage
   - Cloud Messaging
3. Download configuration files:
   - `google-services.json` for Android (place in `android/app/`)
   - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)
4. Update `lib/firebase_options.dart` with your project configuration

### 3. Razorpay Setup
1. Create account at https://razorpay.com
2. Get your API keys from the dashboard
3. Update `AppConstants.razorpayKeyId` in `lib/core/constants/app_constants.dart`

### 4. Google Maps Setup
1. Enable Google Maps SDK in Google Cloud Console
2. Get API key and update `AppConstants.googleMapsApiKey`
3. Add API key to platform-specific files:
   - Android: `android/app/src/main/AndroidManifest.xml`
   - iOS: `ios/Runner/AppDelegate.swift`

### 5. Run the Application
```bash
# For mobile
flutter run

# For web
flutter run -d chrome
```

## Project Structure
```
lib/
├── core/
│   ├── constants/          # App constants
│   ├── services/           # Firebase, location services
│   ├── theme/              # App theming
│   ├── routes/             # Navigation routes
│   ├── utils/              # Utility functions
│   └── bindings/           # Dependency injection
├── features/
│   ├── auth/               # Authentication (MVC)
│   ├── home/               # Home screen (MVC)
│   ├── search/             # Search functionality (MVC)
│   ├── booking/            # Booking system (MVC)
│   ├── profile/            # User profile (MVC)
│   ├── lab/                # Lab management (MVC)
│   └── admin/              # Admin panel (MVC)
├── shared/
│   ├── models/             # Data models
│   └── widgets/            # Reusable widgets
├── l10n/                   # Localization files
└── main.dart               # App entry point
```

## Key Technologies
- **Frontend**: Flutter with Material 3 design
- **Backend**: Firebase (Auth, Firestore, Storage, Messaging)
- **State Management**: GetX
- **Payments**: Razorpay
- **Maps**: Google Maps
- **Localization**: Flutter Intl
- **Architecture**: MVC pattern

## Configuration Files to Update

### 1. Firebase Options (`lib/firebase_options.dart`)
Replace with your Firebase project configuration.

### 2. App Constants (`lib/core/constants/app_constants.dart`)
```dart
static const String razorpayKeyId = 'YOUR_RAZORPAY_KEY';
static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
```

### 3. Android Manifest (`android/app/src/main/AndroidManifest.xml`)
```xml
<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

## Sample Data Structure

### Users Collection
```json
{
  "email": "user@example.com",
  "name": "John Doe",
  "phone": "+919876543210",
  "role": "patient",
  "language": "en",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Labs Collection
```json
{
  "name": "City Diagnostics",
  "description": "Full service diagnostic center",
  "address": "123 Main St, Delhi",
  "latitude": 28.6139,
  "longitude": 77.2090,
  "phone": "+911234567890",
  "email": "info@citydiagnostics.com",
  "ownerId": "lab_owner_uid",
  "workingHours": ["09:00-18:00"],
  "rating": 4.5,
  "isVerified": true,
  "isActive": true
}
```

### Tests Collection
```json
{
  "name": "Complete Blood Count",
  "description": "Comprehensive blood analysis",
  "category": "blood_test",
  "price": 500,
  "labId": "lab_document_id",
  "preparation": "12 hour fasting required",
  "duration": 30,
  "isAvailable": true
}
```

## Development Notes
- The app uses MVC architecture for better code organization
- All prices are in INR (₹)
- Supports both online (Razorpay) and offline payments
- Real-time updates using Firestore streams
- Responsive design works on mobile and web
- Multilingual support with easy language switching

## Testing
```bash
# Run tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## Build for Production
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## Support
For issues and questions, please refer to the documentation or create an issue in the repository.