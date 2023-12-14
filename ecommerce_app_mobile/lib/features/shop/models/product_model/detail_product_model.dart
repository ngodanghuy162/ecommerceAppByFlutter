import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';

class DetailProductModel {
  final String? id;
  final BrandModel brand;
  final ProductModel product;
  final List<ProductVariantModel> listVariants;
  DetailProductModel({
    this.id,
    required this.brand,
    required this.product,
    required this.listVariants,
  });

  toJson() {
    return {
      'brand': brand,
      'product': product,
      'variants': listVariants,
    };
  }

  factory DetailProductModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return DetailProductModel(
        id: document.id,
        brand: data['brand'],
        product: data['product'],
        listVariants: data['variants']);
  }
}
