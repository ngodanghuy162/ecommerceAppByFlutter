import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/features/shop/models/brands/brand_model.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  // Future<BrandModel> queryBrandNamebyId(String brandId) async {
  //   final snapshot = await _db.collection('Brand').doc(brandId).get();
  //   final productData =
  //       snapshot.docs.map((e) => BrandModel.fromSnapShot(e)).single;
  //   return productData;
  // }

  Future<List<BrandModel>> queryAllBrands() async {
    final snapshot = await _db.collection('Brand').get();
    final brandData =
        snapshot.docs.map((e) => BrandModel.fromSnapShot(e)).toList();
    return brandData;
  }

  queryBrandbyId(String brandID) {}
}
