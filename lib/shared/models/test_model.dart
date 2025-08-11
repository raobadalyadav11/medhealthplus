import 'package:cloud_firestore/cloud_firestore.dart';

class TestModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String labId;
  final String preparation;
  final int duration; // in minutes
  final bool isAvailable;
  final List<String> availableSlots;
  final DateTime createdAt;
  final DateTime updatedAt;

  TestModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.labId,
    this.preparation = '',
    this.duration = 30,
    this.isAvailable = true,
    this.availableSlots = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory TestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TestModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      labId: data['labId'] ?? '',
      preparation: data['preparation'] ?? '',
      duration: data['duration'] ?? 30,
      isAvailable: data['isAvailable'] ?? true,
      availableSlots: List<String>.from(data['availableSlots'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'labId': labId,
      'preparation': preparation,
      'duration': duration,
      'isAvailable': isAvailable,
      'availableSlots': availableSlots,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  String get formattedPrice => '₹${price.toStringAsFixed(0)}';
}