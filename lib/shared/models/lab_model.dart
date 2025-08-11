import 'package:cloud_firestore/cloud_firestore.dart';

class LabModel {
  final String id;
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final String email;
  final String ownerId;
  final List<String> workingHours;
  final List<String> holidays;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final bool isActive;
  final List<String> certifications;
  final DateTime createdAt;
  final DateTime updatedAt;

  LabModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.email,
    required this.ownerId,
    required this.workingHours,
    this.holidays = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isVerified = false,
    this.isActive = true,
    this.certifications = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory LabModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LabModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      address: data['address'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      ownerId: data['ownerId'] ?? '',
      workingHours: List<String>.from(data['workingHours'] ?? []),
      holidays: List<String>.from(data['holidays'] ?? []),
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      isVerified: data['isVerified'] ?? false,
      isActive: data['isActive'] ?? true,
      certifications: List<String>.from(data['certifications'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'ownerId': ownerId,
      'workingHours': workingHours,
      'holidays': holidays,
      'rating': rating,
      'reviewCount': reviewCount,
      'isVerified': isVerified,
      'isActive': isActive,
      'certifications': certifications,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}