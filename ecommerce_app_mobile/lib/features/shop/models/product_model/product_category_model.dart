import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCategoryModel {
  final String? id;
  final String name;

  ProductCategoryModel({
    this.id,
    required this.name,
  });

  toJson() {
    return {
      'name': name,
    };
  }

  factory ProductCategoryModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ProductCategoryModel(
      id: document.id,
      name: data['name'],
    );
  }
}
