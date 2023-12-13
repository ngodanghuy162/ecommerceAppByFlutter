import 'package:cloud_firestore/cloud_firestore.dart';

class PopularModel {
  final String? id;
  final List<dynamic>? listProducts;
  PopularModel({this.listProducts, this.id});

  toJson() {
    return {'listProducts': listProducts};
  }

  factory PopularModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return PopularModel(id: document.id, listProducts: data["listProducts"]);
  }
}
