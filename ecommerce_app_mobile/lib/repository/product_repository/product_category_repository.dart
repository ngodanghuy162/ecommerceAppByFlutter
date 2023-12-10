
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_category_model.dart';
import 'package:get/get.dart';

class ProductCategoryRepository extends GetxController{
  static ProductCategoryRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<ProductCategoryModel>> getAllProduct() async {
    final snapshot = await _db
        .collection('ProductCategory').get();
    final productCategoryData = snapshot.docs.map((e) => ProductCategoryModel.fromSnapShot(e)).toList();
    return productCategoryData;
  }

  Future<String> getCategoryDocumentIdByName(String name) async {
    final snapshot = await _db.collection('ProductCategory').where('name', isEqualTo: name).get();

    return 'ProductCategory/${snapshot.docs.first.id}';
  }

}