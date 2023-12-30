import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/order_model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<String> addOrderSuccess(OrderModel orderModel) async {
    var ref = await _db.collection('Order').add(orderModel.toMap()).catchError(
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

  Future<OrderModel> getOrderDetails(String id) async {
    final snapshot = await _db.collection('Order').doc(id).get();
    final orderDetails = OrderModel.fromSnapshot(snapshot);
    return orderDetails;
  }
}
