import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_variant_repository.dart';
import 'package:get/get.dart';

class ProductVariantController extends GetxController {
  static ProductVariantController get instance => Get.find();
  final _productVariantRepo = Get.put(ProductVariantRepository());

  Future<String> createProductVariant(
      ProductVariantModel productVariantModel) async {
    return await _productVariantRepo.createProductVariant(productVariantModel);
  }

  Future<List<ProductVariantModel>> getAllProductVariants(
      String productId) async {
    return await _productVariantRepo.queryAllProductVariants(productId);
  }
}
