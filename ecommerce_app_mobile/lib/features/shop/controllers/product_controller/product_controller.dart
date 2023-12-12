import 'dart:developer';

import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_repository.dart';
import 'package:get/get.dart';

import 'brand_controller.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();
  final _productRepo = Get.put(ProductRepository());
  final brandController = Get.put(BrandController());

  Future<ProductModel> createProduct({
    required String brand_id,
    required String description,
    int? discount,
    required String name,
    required String product_category_id,
    List<dynamic>? rating,
    required List<String> variants_path,
  }) async {
    return await _productRepo.createProduct(
        brand_id: brand_id,
        description: description,
        discount: discount,
        name: name,
        product_category_id: product_category_id,
        rating: rating,
        variants_path: variants_path);
  }

  Future<List<ProductModel>> getAllProductbyBrand(String brandId) async {
    return await _productRepo.queryAllProductsFiltedBrand(brandId);
  }

  Future<List<ProductModel>> getAllProductByName(String keySearch) async {
    log("Da goi tim san pham");
    return await _productRepo.queryAllProductByName(keySearch);
  }
}
