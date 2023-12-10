import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/sell_product/sell_product.dart';

class ProductModel {
  final String? id;
  final String brand_id;
  final String description;
  final String? discount_id;
  final String name;
  final String product_category_id;
  final List<String>? rating;
  final List<String> variants_path;

  ProductModel({
    this.id,
    required this.brand_id,
    required this.description,
    this.discount_id,
    required this.name,
    required this.product_category_id,
    this.rating,
    required this.variants_path,
  });

  toJson() {
    return {
      'brand_id': brand_id,
      'description': description,
      'discount_id': discount_id,
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
      discount_id: data['discount_id'],
      name: data['name'],
      product_category_id: data['product_category_id'],
      rating: data['rating'],
      variants_path: data['variants_path'],
    );
  }
}
