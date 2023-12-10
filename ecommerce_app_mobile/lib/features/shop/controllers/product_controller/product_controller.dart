import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/brand_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_repository.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();
  final _productRepo = Get.put(ProductRepository());
  final brandController = Get.put(BrandController());

  createProduct(ProductModel productModel) {
    _productRepo.createProduct(productModel);
  }

  Future<List<ProductModel>> getAllProductbyBrand(String brandId) async {
    return await _productRepo.queryAllProductsFiltedBrand(brandId);
  }
}
