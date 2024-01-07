import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_category_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_repository.dart';
import 'package:get/get.dart';

class ProductCategoryRepository extends GetxController {
  static ProductCategoryRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final productRepository = Get.put(ProductRepository());

  Future<List<ProductCategoryModel>> queryAllCategories() async {
    final snapshot = await _db.collection('ProductCategory').get();
    final productCategoryData =
        snapshot.docs.map((e) => ProductCategoryModel.fromSnapShot(e)).toList();
    return productCategoryData;
  }

  Future<String> getCategoryDocumentIdByName(String name) async {
    final snapshot = await _db
        .collection('ProductCategory')
        .where('name', isEqualTo: name)
        .get();

    return snapshot.docs.first.id;
  }

  Future<ProductCategoryModel> getCategoryByName(String name) async {
    final snapshot = await _db
        .collection('ProductCategory')
        .where('name', isEqualTo: name)
        .get();
    return snapshot.docs.map((e) => ProductCategoryModel.fromSnapShot(e)).first;
  }

  Future<List<ProductCategoryModel>> getCategoriesByShopEmail(String shopEmail,
      void Function(List<ProductModel> list) setProductList) async {
    final productList =
        await productRepository.queryProductsByShopEmail(shopEmail);

    setProductList(productList);
    var seen = <String>{};
    final uniqueList =
        productList.where((element) => seen.add(element.product_category_id));
    final categoryList = uniqueList.map((e) => e.product_category_id).toList();

    List<ProductCategoryModel> result = [];
    for (var element in categoryList) {
      final snapshot =
          await _db.collection('ProductCategory').doc(element).get();
      result.add(ProductCategoryModel.fromSnapShot(snapshot));
    }
    return result;
  }
}
