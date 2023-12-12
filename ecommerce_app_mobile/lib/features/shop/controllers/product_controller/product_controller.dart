import 'dart:math';

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

  Future<List<ProductModel>> getAllProduct() async {
    List list = await _productRepo.getAllProduct();
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
