import 'dart:math';

import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/brand_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_repository.dart';
import 'package:get/get.dart';

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
    return await _productRepo.queryAllProductByName(keySearch);
  }

  Future<List<ProductModel>> getAllProduct() async {
    List list = await _productRepo.queryAllProducts();
    list = shuffle(list);
    return list as List<ProductModel>;
  }
}

List shuffle(List array) {
  var random = Random(); //import 'dart:math';

  // Go through all elementsof list
  for (var i = array.length - 1; i > 0; i--) {
    // Pick a random number according to the lenght of list
    var n = random.nextInt(i + 1);
    var temp = array[i];
    array[i] = array[n];
    array[n] = temp;
  }
  return array;
}
