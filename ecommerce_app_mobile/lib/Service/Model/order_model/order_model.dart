// ignore: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String? id;
  final String shopEmail;
  String status;
  final String paymentId;
  final String userId;
  final Map<String, dynamic> package;
  final Map<String, dynamic> shopAddress;
  final Map<String, dynamic> userAddress;

  OrderModel(
      {this.id,
      required this.shopEmail,
      required this.package,
      required this.paymentId,
      required this.status,
      required this.userId,
      required this.shopAddress,
      required this.userAddress});

  Map<String, dynamic> toMap() {
    return {
      'shopEmail': shopEmail,
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
        shopEmail: data['shopEmail'],
        package: data['package'],
        paymentId: data['payment_id'],
        status: data['status'],
        userId: data['user_id'],
        shopAddress: data['shop_address'],
        userAddress: data['user_address']);
  }
}
