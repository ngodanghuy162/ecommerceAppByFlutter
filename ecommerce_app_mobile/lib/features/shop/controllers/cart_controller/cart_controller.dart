import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  RxInt quantity = 1.obs;

  ProductVariantModel? chosenVariant;

  increseQuantity() {
    quantity.value++;
  }

  decreseQuantity() {
    quantity.value--;
  }
}
