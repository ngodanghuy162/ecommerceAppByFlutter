import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/brand_repository.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_repository.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_variant_repository.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  static WishlistController get instance => Get.find();
  RxInt listProductSize = 0.obs;
  RxList listRxProduct = [].obs;
  List<ProductModel> listProduct = [];
  List<List<ProductVariantModel>> listVariant = [];
  List<BrandModel> listBrand = [];
  Future<List<String?>> getWishlist() async {
    listProduct.clear();
    listVariant.clear();
    listBrand.clear();
    listProductSize.value = 0;
    List<String>? listProductId =
        await UserRepository.instance.getUserWishlist();
    listProductSize.value = listProductId!.length;
    await Future.forEach(listProductId, (entry) async {
      ProductModel product =
          await ProductRepository.instance.getProductById(entry);
      listProduct.add(product);
      List listVariantId = product.variants_path;
      List<ProductVariantModel> tmp = [];
      for (int i = 0; i < listVariantId.length; i++) {
        ProductVariantModel variant = await ProductVariantRepository.instance
            .getVariantById(listVariantId[i]);
        tmp.add(variant);
      }
      listVariant.add(tmp);
      BrandModel brand =
          await BrandRepository.instance.getBrandById(product.brand_id);
      listBrand.add(brand);
    });
    return listProductId;
  }
}
