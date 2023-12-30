// ignore: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final String? id;
  final String userId;
  final String shopId;
  final double shipping;
  final double total;
  final double discount;
  final String paymentMethod;
  final Timestamp paymentDate;

  PaymentModel({
    required this.paymentDate,
    this.id,
    required this.userId,
    required this.shopId,
    this.discount = 0,
    required this.paymentMethod,
    required this.total,
    required this.shipping,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'shop_id': shopId,
      'total': total,
      'discount': discount,
      'payment_method': paymentMethod,
      'payment_date': paymentDate,
      'shipping': shipping
    };
  }

  factory PaymentModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return PaymentModel(
        id: document.id,
        userId: data['user_id'],
        shopId: data['shop_id'],
        paymentMethod: data['payment_method'],
        total: data['total'],
        discount: data['discount'],
        paymentDate: data['payment_date'],
        shipping: data['shipping']);
  }
}
