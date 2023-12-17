import 'package:ecommerce_app_mobile/features/shop/models/product_model/detail_product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_category_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_category_repository.dart';
import 'package:get/get.dart';

class ProductCategoryController extends GetxController {
  static ProductCategoryController get instance => Get.find();
  final _productCategoryRepo = Get.put(ProductCategoryRepository());

  var choosedCategories = "".obs;
  List<DetailProductModel> listCategoryProducts = [];

  Future<List<ProductCategoryModel>> getAllCategories() {
    return _productCategoryRepo.queryAllCategories();
  }

  getCategoryDocumentIdByName(String name) async {
    return await _productCategoryRepo.getCategoryDocumentIdByName(name);
  }
}
