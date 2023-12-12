import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String? id;
  final String brand_id;
  final String description;
  final int? discount;
  final String name;
  final String product_category_id;
  final List<dynamic>? rating;
  final List<String>? variants_path;

  ProductModel({
    this.id,
    required this.brand_id,
    required this.description,
    this.discount,
    required this.name,
    required this.product_category_id,
    this.rating,
    required this.variants_path,
  });

  toJson() {
    return {
      'id': id,
      'brand_id': brand_id,
      'description': description,
      'discount': discount,
      'name': name,
      'product_category_id': product_category_id,
      'rating': rating,
      'variants': variants_path,
    };
  }

  factory ProductModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ProductModel(
      id: document.id,
      brand_id: data['brand_id'],
      description: data['description'],
      discount: data['discount'],
      name: data['name'],
      product_category_id: data['product_category_id'],
      rating: data['rating'] ?? null,
      variants_path: data['variants_path'],
    );
  }
}
