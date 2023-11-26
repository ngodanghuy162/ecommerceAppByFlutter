import 'package:cloud_firestore/cloud_firestore.dart';

class ProductVariantModel {
  late String size;
  late String color;
  late double price;

  ProductVariantModel({
    required this.size,
    required this.color,
    required this.price
  });

  toJson() {
    return {
      'size': size,
      'color': color,
      'price': price,
    };
  }

  factory ProductVariantModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ProductVariantModel(
      size: data['size'],
      color: data['color'],
      price: data['price']
    );
  }

}