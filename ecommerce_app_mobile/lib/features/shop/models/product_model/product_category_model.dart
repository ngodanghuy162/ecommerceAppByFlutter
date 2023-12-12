import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCategoryModel {
  final String? id;
  final String imageUrl;
  final String name;

  ProductCategoryModel({
    this.id,
    this.imageUrl = '',
    required this.name,
  });

  toJson() {
    return {'name': name, 'image_url': imageUrl};
  }

  factory ProductCategoryModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ProductCategoryModel(
        id: document.id, name: data['name'], imageUrl: data['image_url']);
  }
}
