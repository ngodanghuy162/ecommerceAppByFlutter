import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/product_review_model/reply_review_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReplyReviewRepository extends GetxController {
  static ReplyReviewRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createReplyReview(ReplyReviewModel replyReviewModel) async {
    await _db
        .collection('Product')
        .doc('3o2frQlDs3Zh75qLF0c9')
        .collection('Reply')
        .add(replyReviewModel.toJson())
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

  Future<List<ReplyReviewModel>> getAllReplyReview({String? productId}) async {
    final snapshot = await _db.collection('Product').doc('3o2frQlDs3Zh75qLF0c9').collection('Reply').get();
    final replyData = snapshot.docs.map((e) => ReplyReviewModel.fromSnapShot(e)).toList();
    return replyData;

  }
}
