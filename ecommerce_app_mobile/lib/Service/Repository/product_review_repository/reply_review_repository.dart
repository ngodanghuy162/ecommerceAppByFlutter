import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/product_review_model/reply_review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class ReplyReviewRepository extends GetxController {
  static ReplyReviewRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> createReplyReview(
      ReplyReviewModel replyReviewModel, String productId) async {
    await _db
        .collection('Product')
        .doc(productId)
        .collection('Reply')
        .add(replyReviewModel.toJson())
        .catchError((error, stacktrace) {
      () => SmartDialog.showNotify(
            msg: 'Something went wrong, try again?',
            notifyType: NotifyType.failure,
            displayTime: const Duration(seconds: 1),
          );
    });
  }

  Future<List<ReplyReviewModel>> getAllReplyReview(
      {required String productId}) async {
    final snapshot = await _db
        .collection('Product')
        .doc(productId)
        .collection('Reply')
        .get();
    final replyData =
        snapshot.docs.map((e) => ReplyReviewModel.fromSnapShot(e)).toList();
    return replyData;
  }
}
