import 'dart:developer';

import 'package:ecommerce_app_mobile/features/shop/controllers/brands_controller/brands_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_repository.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();
  final _productRepo = Get.put(ProductRepository());
  final brandController = Get.put(BrandsController());

  Future<ProductModel> createProduct({
    required String brand_id,
    required String description,
    String? discount_id,
    required String image_url,
    required String name,
    required String product_category_id,
    List<dynamic>? rating,
    required List<String> variants_path,
  }) async {
    return await _productRepo.createProduct(
        brand_id: brand_id,
        description: description,
        discount_id: discount_id,
        image_url: image_url,
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
