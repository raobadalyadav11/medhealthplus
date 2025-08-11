class AppConstants {
  static const String appName = 'MedHealthPlus';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String labsCollection = 'labs';
  static const String testsCollection = 'tests';
  static const String bookingsCollection = 'bookings';
  static const String reportsCollection = 'reports';

  // User Roles
  static const String patientRole = 'patient';
  static const String labOwnerRole = 'lab_owner';
  static const String adminRole = 'admin';

  // Test Categories
  static const String xrayCategory = 'xray';
  static const String ultrasoundCategory = 'ultrasound';
  static const String bloodTestCategory = 'blood_test';

  // Booking Status
  static const String pendingStatus = 'pending';
  static const String confirmedStatus = 'confirmed';
  static const String completedStatus = 'completed';
  static const String cancelledStatus = 'cancelled';

  // Payment Methods
  static const String onlinePayment = 'online';
  static const String offlinePayment = 'offline';

  // Commission Rate
  static const double commissionRate = 0.15; // 15%

  // Razorpay
  static const String razorpayKeyId = 'rzp_test_l6BDLcUA2VHmgk';
  static const String razorpayKeySecret = 'TqH2Ui9g0hOicRJOwKzhYMzX';

  // Google Maps
  static const String googleMapsApiKey = 'AIzaSyBvOiCP38UnlzPjIBNaOiB9rK7VdVyLFKo';

  // Default Location (Delhi)
  static const double defaultLatitude = 28.6139;
  static const double defaultLongitude = 77.2090;
}
