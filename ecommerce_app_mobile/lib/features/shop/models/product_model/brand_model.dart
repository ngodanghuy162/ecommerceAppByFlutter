import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  final String? user_id;
  final String name;
  final bool? is_verified;
  final String? imageURL;

  BrandModel({
    this.user_id,
    required this.name,
    this.is_verified,
    this.imageURL,
  });

  toJson() {
    return {
      'user_id': user_id,
      'name': name,
      'is_verified': is_verified,
      'imageURL': imageURL,
    };
  }

  factory BrandModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BrandModel(
      user_id: data['user_id'],
      name: data['name'],
      is_verified: data['is_verified'],
      imageURL: data['imageURL'],
    );
  }

}