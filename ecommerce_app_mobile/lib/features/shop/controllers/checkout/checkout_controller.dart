import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/shop_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/brand_repository.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_repository.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_variant_repository.dart';
import 'package:ecommerce_app_mobile/repository/shop_repository/shop_repository.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();
  final shopRepository = Get.put(ShopRepository());
  final productVariantRepository = Get.put(ProductVariantRepository());
  final productRepository = Get.put(ProductRepository());
  final brandRepository = Get.put(BrandRepository());

  Future<Map<String, dynamic>?> getShopAndProductsCheckoutInfo(
      Map<String, Map<String, int>> shopAndProducts) async {
    ShopModel shopData = await shopRepository.getShopByEmail(
      shopAndProducts.keys.first,
    );

    final productsKeys =
        shopAndProducts[shopAndProducts.keys.first]!.keys.toList();

    final result = [];

    for (var element in productsKeys) {
      final ProductModel? productModel =
          await productRepository.getProductByVariantId(element);
      final ProductVariantModel productVariantModel =
          await productVariantRepository.getVariantById(element);
      final BrandModel brandModel =
          await brandRepository.getBrandById(productModel!.brand_id);

      result.add({
        'product': productModel,
        'productVariant': productVariantModel,
        'brand': brandModel,
        'quantity': shopAndProducts[shopAndProducts.keys.first]![element]
      });
    }

    print(result);

    return {'shopModel': shopData, 'products': result};
  }
}
