import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String brandId;
  final String description;
  final String? discountId;
  final String imageUrl;
  final String name;
  final String productCategoryId;
  final List<dynamic>? rating;
  final List<String>? variantsPath;
  final int discount;

  ProductModel({
    required this.id,
    required this.brandId,
    required this.description,
    this.discountId,
    required this.imageUrl,
    required this.name,
    required this.productCategoryId,
    this.rating,
    required this.variantsPath,
    required this.discount,
  });

  toJson() {
    return {
      'brand_id': brandId,
      'description': description,
      'discount_id': discountId,
      'image_url': imageUrl,
      'name': name,
      'product_category_id': productCategoryId,
      'rating': rating,
      'variants': variantsPath,
      'discount': discount
    };
  }

  factory ProductModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ProductModel(
      id: document.id,
      brandId: data['brand_id'],
      discount: data['discount'],
      description: data['description'],
      discountId: data['discount_id'],
      imageUrl: data['image_url'],
      name: data['name'],
      productCategoryId: data['product_category_id'],
      rating: data['rating'],
      variantsPath: data['variants_path'],
    );
  }
}
