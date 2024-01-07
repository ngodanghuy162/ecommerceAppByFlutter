import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/order_model/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class PaymentRepository extends GetxController {
  static PaymentRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<String> addPaymentSuccess(PaymentModel paymentModel) async {
    var ref =
        await _db.collection('Payment').add(paymentModel.toMap()).catchError(
      (error, stacktrace) {
        () => SmartDialog.showNotify(
              msg: 'Something went wrong, try again?',
              notifyType: NotifyType.failure,
              displayTime: const Duration(seconds: 1),
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
