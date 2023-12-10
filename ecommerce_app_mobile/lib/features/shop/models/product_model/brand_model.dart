import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  final String? id;
  final String? userId;
  final String name;
  final bool? isVerified;
  final String? imageURL;

  BrandModel({
    this.id,
    this.userId,
    required this.name,
    this.isVerified,
    this.imageURL,
  });

  toJson() {
    return {
      'user_id': userId,
      'name': name,
      'is_verified': isVerified,
      'imageURL': imageURL,
    };
  }

  factory BrandModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BrandModel(
      id: document.id,
      userId: data['user_id'],
      name: data['name'],
      isVerified: data['is_verified'],
      imageURL: data['imageURL'],
    );
  }
}
