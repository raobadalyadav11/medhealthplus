import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String patientId;
  final String labId;
  final String testId;
  final DateTime bookingDate;
  final String timeSlot;
  final double totalAmount;
  final double discountAmount;
  final double finalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String bookingStatus;
  final String? couponCode;
  final String? razorpayPaymentId;
  final String? reportUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingModel({
    required this.id,
    required this.patientId,
    required this.labId,
    required this.testId,
    required this.bookingDate,
    required this.timeSlot,
    required this.totalAmount,
    this.discountAmount = 0.0,
    required this.finalAmount,
    required this.paymentMethod,
    this.paymentStatus = 'pending',
    this.bookingStatus = 'pending',
    this.couponCode,
    this.razorpayPaymentId,
    this.reportUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      patientId: data['patientId'] ?? '',
      labId: data['labId'] ?? '',
      testId: data['testId'] ?? '',
      bookingDate: (data['bookingDate'] as Timestamp).toDate(),
      timeSlot: data['timeSlot'] ?? '',
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      discountAmount: (data['discountAmount'] ?? 0.0).toDouble(),
      finalAmount: (data['finalAmount'] ?? 0.0).toDouble(),
      paymentMethod: data['paymentMethod'] ?? '',
      paymentStatus: data['paymentStatus'] ?? 'pending',
      bookingStatus: data['bookingStatus'] ?? 'pending',
      couponCode: data['couponCode'],
      razorpayPaymentId: data['razorpayPaymentId'],
      reportUrl: data['reportUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'patientId': patientId,
      'labId': labId,
      'testId': testId,
      'bookingDate': Timestamp.fromDate(bookingDate),
      'timeSlot': timeSlot,
      'totalAmount': totalAmount,
      'discountAmount': discountAmount,
      'finalAmount': finalAmount,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'bookingStatus': bookingStatus,
      'couponCode': couponCode,
      'razorpayPaymentId': razorpayPaymentId,
      'reportUrl': reportUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  String get formattedFinalAmount => '₹${finalAmount.toStringAsFixed(0)}';
  String get formattedTotalAmount => '₹${totalAmount.toStringAsFixed(0)}';
  String get formattedDiscountAmount => '₹${discountAmount.toStringAsFixed(0)}';
}