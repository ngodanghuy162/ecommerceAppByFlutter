import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/product_review_model/product_review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class ProductReviewRepository extends GetxController {
  static ProductReviewRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createReview(ProductReviewModel productReviewModel,
      {String? productId}) async {
    await _db
        .collection('Product')
        .doc(productId)
        .collection('Review')
        .add(productReviewModel.toJson())
        .whenComplete(() => SmartDialog.showNotify(
              msg: 'Product review posted successfully.!',
              notifyType: NotifyType.success,
              displayTime: const Duration(seconds: 1),
            ))
        .catchError((error, stacktrace) {
      () => SmartDialog.showNotify(
            msg: 'Something went wrong, try again?',
            notifyType: NotifyType.failure,
            displayTime: const Duration(seconds: 1),
          );
    });
  }

  Future<List<ProductReviewModel>> getAllReview(
      {required String productId}) async {
    final snapshot = await _db
        .collection('Product')
        .doc(productId)
        .collection('Review')
        .get();
    final reviewData =
        snapshot.docs.map((e) => ProductReviewModel.fromSnapShot(e)).toList();
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
