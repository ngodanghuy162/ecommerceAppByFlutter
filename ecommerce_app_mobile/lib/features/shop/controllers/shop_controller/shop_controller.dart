
import 'package:ecommerce_app_mobile/features/shop/models/shop_model.dart';
import 'package:ecommerce_app_mobile/repository/shop_repository/shop_repository.dart';
import 'package:get/get.dart';

class ShopController extends GetxController {
  static ShopController get instance => Get.find();

  Future<void> addProductToShop(String productId) async {
    return await ShopRepository.instance.addProduct(productId);
  }

  Future<void> addVoucher(String voucher) async {
    return await ShopRepository.instance.addVoucher(voucher);
  }

  Future<String> createShop(ShopModel shopModel) async {
    return await ShopRepository.instance.createShop(shopModel);
  }

  Future<ShopModel> findShopByEmail(String email) async {
    return await ShopRepository.instance.getShopByEmail(email);
  }

  Future<ShopModel> findShopByName(String name) async {
    return await ShopRepository.instance.getShopByName(name);
  }
}
