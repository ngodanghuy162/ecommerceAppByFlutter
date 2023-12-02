import 'dart:developer';

import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_repository.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();
  final _productRepo = Get.put(ProductRepository());

  createProduct(ProductModel productModel) {
    _productRepo.createProduct(productModel);
  }

  Future<List<ProductModel>> getAllProductbyBrand(String brandId) async {
    return await _productRepo.queryAllProductsFiltedBrand(brandId);
  }

  Future<List<ProductModel>> getAllProductByName(String keySearch) async {
    log("Da goi tim san pham");
    return await _productRepo.queryAllProductByName(keySearch);
  }
}
