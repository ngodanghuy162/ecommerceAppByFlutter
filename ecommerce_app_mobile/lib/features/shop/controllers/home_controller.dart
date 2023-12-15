import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/popular_product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  final carousalCurrentIndex = 0.obs;

  void updatePageIndicator(index) {
    carousalCurrentIndex.value = index;
  }

  Future<List<dynamic>> getListModelID() async {
    final snapshot = await _db.collection('PopularProduct').get();
    final listIDdata =
        snapshot.docs.map((e) => PopularModel.fromSnapShot(e)).toList();
    return listIDdata;
  }

  Future<List<ProductModel>> getPopularProducts() async {
    List listModel = await getListModelID();
    PopularModel model = listModel[0];
    final query = _db
        .collection('Product')
        .where(FieldPath.documentId, whereIn: model.listProducts);
    final snapshot = await query.get();
    return snapshot.docs.map((e) => ProductModel.fromSnapShot(e)).toList();
  }
}
