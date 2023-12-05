import 'package:cloud_firestore/cloud_firestore.dart';

class ProductVariantModel {
  final String id;
  late String size;
  late String color;
  late double price;
  late String imageURL;

  ProductVariantModel({
    required this.size,
    required this.color,
    required this.price,
    required this.imageURL,
  });

  toJson() {
    return {
      'size': size,
      'color': color,
      'price': price,
      'imageURL': imageURL,
    };
  }

  factory ProductVariantModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ProductVariantModel(
      size: data['size'],
      color: data['color'],
      price: data['price'],
      imageURL: data['imageURL'],
    );
  }
}
