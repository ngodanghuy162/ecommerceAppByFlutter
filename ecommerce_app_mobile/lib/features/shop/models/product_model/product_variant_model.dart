import 'package:cloud_firestore/cloud_firestore.dart';

class ProductVariantModel {
  final String? id;
  late String size;
  late String color;
  late double price;
  late String imageURL;
  late int quantity;
  late String descriptionVariant;
  late int height;
  late int length;
  late int weight;
  late int width;

  ProductVariantModel({
    this.id,
    required this.size,
    required this.color,
    required this.price,
    required this.imageURL,
    required this.quantity,
    required this.descriptionVariant,
    required this.height,
    required this.length,
    required this.weight,
    required this.width,
  });

  toJson() {
    return {
      'size': size,
      'color': color,
      'price': price,
      'imageURL': imageURL,
      'quantity': quantity,
      'descriptionVariant': descriptionVariant,
      'height': height,
      'weight': weight,
      'length': length,
      'width': width,
    };
  }

  factory ProductVariantModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ProductVariantModel(
      id: document.id,
      size: data['size'],
      color: data['color'],
      price: data['price'] + 0.0,
      imageURL: data['imageURL'],
      quantity: data['quantity'],
      descriptionVariant: data['descriptionVariant'],
      height: data['height'],
      weight: data['weight'],
      width: data['width'],
      length: data['length'],
    );
  }
}
