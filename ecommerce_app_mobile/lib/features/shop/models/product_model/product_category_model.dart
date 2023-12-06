import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCategoryModel {
  final String name;

  ProductCategoryModel({
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
      name: data['name'],
    );
  }
}