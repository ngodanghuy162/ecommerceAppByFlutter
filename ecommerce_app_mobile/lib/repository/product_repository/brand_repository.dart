import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<String> createBrand(BrandModel brandModel) async {
    var id = await _db
        .collection('Brand')
        .add(brandModel.toJson())
        .catchError((error, stacktrace) {
      () => Get.snackbar(
            'Lỗi',
            'Có gì đó không đúng, thử lại?',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.red,
          );
      print(error.toString());
    });
    return id.id;
  }

  Future<String> checkDuplicatedBrand(String name) async {
    var queryBrand =
        await _db.collection('Brand').where('name', isEqualTo: name).get();

    if (queryBrand.docs.isNotEmpty) {
      // Nếu có tài liệu thì trả về ID của tài liệu đầu tiên
      return queryBrand.docs.first.id;
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
