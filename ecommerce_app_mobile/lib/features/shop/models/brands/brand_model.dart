import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BrandModel {
  final String image_url;
  final bool is_verified;
  final String name;
  final user_id;

  BrandModel({
    required this.image_url,
    required this.is_verified,
    required this.name,
    required this.user_id,
  });

  toJson() {
    return {
      'image_url': image_url,
      'is_verified': is_verified,
      'name': name,
      'user_id': user_id,
    };
  }

  factory BrandModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BrandModel(
        image_url: data['image_url'],
        is_verified: data['is_verified'],
        name: data['name'],
        user_id: data['user_id']);
  }
}
