import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/order_model/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentRepository extends GetxController {
  static PaymentRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<String> addPaymentSuccess(PaymentModel paymentModel) async {
    var ref =
        await _db.collection('Payment').add(paymentModel.toMap()).catchError(
      (error, stacktrace) {
        () => Get.snackbar(
              'Lỗi',
              'Có lỗi xảy ra, liên hệ quản trị viên để được hỗ trợ',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent.withOpacity(0.1),
              colorText: Colors.red,
            );
      },
    );
    return ref.id;
  }

  Future<PaymentModel> getPaymentDetails(String id) async {
    final snapshot = await _db.collection('Payment').doc(id).get();
    final paymentDetails = PaymentModel.fromSnapshot(snapshot);
    return paymentDetails;
  }
}
