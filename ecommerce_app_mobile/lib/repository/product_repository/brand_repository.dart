import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<String> createBrand(BrandModel brandModel) async {
    var id = await _db
        .collection('Brand')
        .add(brandModel.toJson())
        .catchError((error, stacktrace) {
      () => SmartDialog.showNotify(
            msg: 'Something went wrong, try again?',
            notifyType: NotifyType.failure,
            displayTime: const Duration(seconds: 1),
          );
      print(error.toString());
    });
    return id.id;
  }

  Future<String> checkDuplicatedBrand(String name) async {
    var queryBrand = await _db.collection('Brand').get();

    for (var document in queryBrand.docs) {
      var documentName = document['name'].toLowerCase();
      if (documentName ==
          name.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase()) {
        return document.id;
      }
    }
    return 'false';
  }

  Future<BrandModel> queryBrandById(String brandId) async {
    final snapshot = await _db
        .collection('Brand')
        .where(FieldPath.documentId, isEqualTo: brandId)
        .get();
    final brandData =
        snapshot.docs.map((e) => BrandModel.fromSnapShot(e)).single;
    return brandData;
  }

  Future<List<BrandModel>> queryAllBrands() async {
    final snapshot = await _db.collection('Brand').get();
    final brandData =
        snapshot.docs.map((e) => BrandModel.fromSnapShot(e)).toList();
    return brandData;
  }

  Future<BrandModel> getBrandById(String id) async {
    final snapshot = await _db.collection('Brand').doc(id).get();
    if (snapshot.exists) {
      // Nếu document tồn tại, lấy dữ liệu từ snapshot và trả về đối tượng ProductVariantModel
      return BrandModel.fromSnapShot(snapshot);
    } else {
      // Nếu document không tồn tại, có thể xử lý theo ý bạn, ví dụ, ném một ngoại lệ
      throw Exception('Brand with id $id not found');
    }
  }
}
