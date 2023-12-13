import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  final String? id;
  final String? imageUrl;
  final bool isVerified;
  final String name;
  final String? userId;

  BrandModel({
    this.id,
    this.imageUrl,
    this.isVerified = true,
    required this.name,
    this.userId,
  });

  toJson() {
    return {
      'image_url': imageUrl,
      'is_verified': isVerified,
      'name': name,
      'user_id': userId,
    };
  }

  factory BrandModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BrandModel(
        id: document.id,
        imageUrl: data['imageURL'],
        isVerified: data['is_verified'],
        name: data['name'],
        userId: data['user_id']);
  }
}
