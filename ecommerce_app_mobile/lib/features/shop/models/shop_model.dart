import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/common/constant/cloudFieldName/shop_field.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

class ShopModel {
  String? id;
  Map<String, dynamic>? address = null;
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
    Map<String, dynamic>? address,
    required this.owner,
    String? image,
    this.income = 0,
    List<String>? order,
    List<String>? product,
    List<String>? voucher,
  })  : address = address ?? null,
        image = image ?? TImages.darkAppLogo,
        order = order ?? null,
        product = product ?? null,
        voucher = voucher ?? null;

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
      name: data?["name"] ?? null,
      address: data?['address'] ?? null,
      owner: data?['owner'] ?? '',
      income: data?['income'] ?? 0,
      image: data?[shopImageField] ?? null,
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
