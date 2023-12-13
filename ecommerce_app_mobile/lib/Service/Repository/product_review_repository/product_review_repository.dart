import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/product_review_model/product_review_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductReviewRepository extends GetxController {
  static ProductReviewRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createReview(ProductReviewModel productReviewModel, {String? productId}) async {
    productId = '3o2frQlDs3Zh75qLF0c9';
    await _db
        .collection('Product')
        .doc('3o2frQlDs3Zh75qLF0c9')
        .collection('Review')
        .add(productReviewModel.toJson())
        .catchError((error, stacktrace) {
      () => Get.snackbar(
            'Lỗi',
            'Có gì đó không đúng, thử lại?',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.red,
          );
    });
  }

  Future<List<ProductReviewModel>> getAllReview({String? productId}) async {
    final snapshot = await _db.collection('Product').doc('3o2frQlDs3Zh75qLF0c9').collection('Review').get();
    final reviewData = snapshot.docs.map((e) => ProductReviewModel.fromSnapShot(e)).toList();
    return reviewData;

  }

  // Future<List<ProductModel>> queryAllProductsFiltedBrand(String brandId) async {
  //   final snapshot =
  //   await productCollection.where('brand_id', isEqualTo: brandId).get();
  //   final productData =
  //   snapshot.docs.map((e) => ProductModel.fromSnapShot(e)).toList();
  //   return productData;
  // }

}