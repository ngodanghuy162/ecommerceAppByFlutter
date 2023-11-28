
import 'package:ecommerce_app_mobile/repository/product_repository/product_category_repository.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();
  final _productRepo = Get.put(ProductCategoryRepository());

  getAllProduct() {
    _productRepo.getAllProduct();
  }

  getCategoryDocumentIdByName(String name) async {
    return await _productRepo.getCategoryDocumentIdByName(name);
  }
}