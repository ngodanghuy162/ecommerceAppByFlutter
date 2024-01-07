import 'package:cloud_firestore/cloud_firestore.dart';

class VoucherModel {
  final String? id;
  final String name;
  final int discount;
  final String? shopEmail; // null nếu voucher apply tất cả sản phẩm
  final DateTime outDateTime;
  final String? description;
  final String? brand;

  VoucherModel(
      {this.id,
      required this.name,
      required this.discount,
      this.shopEmail,
      required this.outDateTime,
      this.description,
      this.brand});

  toJson() {
    return {
      'name': name,
      'discount': discount,
      'shop_email': shopEmail,
      'out_date_time': outDateTime,
      'description': description,
      'brand': brand
    };
  }

  factory VoucherModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return VoucherModel(
        id: document.id,
        name: data['name'],
        discount: data['discount'],
        shopEmail: data['shop_email'],
        outDateTime: data['out_date_time'],
        brand: data['brand'],
        description: data['description']);
  }
}
