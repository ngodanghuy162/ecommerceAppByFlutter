import 'package:cloud_firestore/cloud_firestore.dart';

class VoucherModel {
  final String? id;
  final String name;
  final int discount;
  final String? fromShop; // id shop
  final bool isUsed;
  final DateTime outDateTime;
  final String? description;

  VoucherModel(
      {this.id,
      required this.name,
      required this.discount,
      this.fromShop = "",
      this.isUsed = false,
      required this.outDateTime,
      this.description});

  toJson() {
    return {
      'name': name,
      'discount': discount,
      'from_shop': fromShop,
      'is_used': isUsed,
      'out_date_time': outDateTime,
      'description': description
    };
  }

  factory VoucherModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return VoucherModel(
        id: document.id,
        name: data['name'],
        discount: data['discount'],
        fromShop: data['from_shop'],
        isUsed: data['is_used'],
        outDateTime: data['out_date_time'],
        description: data['description']);
  }
}
