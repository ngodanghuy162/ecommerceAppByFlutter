import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/features/shop/models/brands/brand_model.dart';
import 'package:get/get.dart';

class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<BrandModel> queryBrandById(String brandId) async {
    final snapshot =
        await _db.collection('Brand').where('Brand', isEqualTo: brandId).get();
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
}
