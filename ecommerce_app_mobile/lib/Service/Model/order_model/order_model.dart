// ignore: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String? id;
  final String shopId;
  final String status;
  final String paymentId;
  final String userId;
  final List<Map<String, dynamic>> package;
  final Map<String, dynamic> shopAddress;
  final Map<String, dynamic> userAddress;

  OrderModel(
      {this.id,
      required this.shopId,
      required this.package,
      required this.paymentId,
      required this.status,
      required this.userId,
      required this.shopAddress,
      required this.userAddress});

  Map<String, dynamic> toMap() {
    return {
      'shop_id': shopId,
      'package': package,
      'payment_id': paymentId,
      'status': status,
      'user_id': userId,
      'shop_address': shopAddress,
      'user_address': userAddress
    };
  }

  factory OrderModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return OrderModel(
        id: document.id,
        shopId: data['shop_id'],
        package: data['package'],
        paymentId: data['payment_id'],
        status: data['status'],
        userId: data['user_id'],
        shopAddress: data['shop_address'],
        userAddress: data['user_address']);
  }
}
