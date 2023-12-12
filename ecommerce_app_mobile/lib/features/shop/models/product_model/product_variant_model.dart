import 'package:cloud_firestore/cloud_firestore.dart';

class ProductVariantModel {
  final String? id;
  late String size;
  late String color;
  late double price;
  late String imageURL;
  late String? productId;

  ProductVariantModel({
    this.id,
    required this.size,
    required this.color,
    required this.price,
    required this.imageURL,
    this.productId,
  });

  toJson() {
    return {
      'size': size,
      'color': color,
      'price': price,
      'imageURL': imageURL,
      'product_id': productId
    };
  }

  factory ProductVariantModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ProductVariantModel(
      id: document.id,
      size: data['size'],
      color: data['color'],
      price: data['price'],
      imageURL: data['imageURL'],
    );
  }
}
