import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/common/constant/cloudFieldName/shop_field.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';

class ShopModel {
  String? id;
  List<Map<String, dynamic>>? address;
  final String name;
  final String owner;
  String? image;
  final int income;
  final List<String>? order;
  final List<String>? product;
  final List<String>? voucher;

  ShopModel({
    this.id,
    required this.name,
    this.address,
    required this.owner,
    String? image,
    this.income = 0,
    this.order,
    this.product,
    this.voucher,
  }) : image = image ?? TImages.darkAppLogo;

  toJson() {
    return {
      "name": name,
      addressField: address,
      ownerField: owner,
      incomeField: income,
      shopImageField: image,
      orderField: order,
      productField: product,
      voucher: voucher,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      nameField: name,
      addressField: address,
      ownerField: owner,
      incomeField: income,
      shopImageField: image,
      orderField: order,
      productField: product,
      voucherField: voucher,
    };
  }

  // Factory method to create ShopModel from a Firestore DocumentSnapshot
  factory ShopModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    return ShopModel(
      id: snapshot.id,
      name: data?["name"],
      address: (data?['address'] as List)
          .map((item) => item as Map<String, dynamic>)
          .toList(),
      owner: data?['owner'] ?? '',
      income: data?['income'] ?? 0,
      image: data?[shopImageField],
      order:
          (data?['order'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      product: (data?['product'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      voucher: (data?['voucher'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }
}
