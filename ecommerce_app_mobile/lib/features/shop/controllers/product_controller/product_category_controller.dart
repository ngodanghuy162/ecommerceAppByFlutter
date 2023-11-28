
import 'package:ecommerce_app_mobile/repository/product_repository/product_category_repository.dart';
import 'package:get/get.dart';

class ProductCategoryController extends GetxController {
  static ProductCategoryController get instance => Get.find();
  final _productCategoryRepo = Get.put(ProductCategoryRepository());

  getAllProduct() {
    _productCategoryRepo.getAllProduct();
  }

  getCategoryDocumentIdByName(String name) async {
    return await _productCategoryRepo.getCategoryDocumentIdByName(name);
  }
}