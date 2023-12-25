import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_repository.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_variant_repository.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  RxInt quantity = 1.obs;

  RxDouble totalAmount = 0.0.obs;

  void updateTotalAmount() {
    // Tính tổng của mảng eachPriceInCart
    double sum =
        eachPriceInCart.fold(0, (previous, current) => previous + current);
    // Cập nhật giá trị của biến totalAmount
    totalAmount.value = sum;
    print("Sum: ${sum.toString()}");
  }

  ProductVariantModel? chosenVariant;

  RxInt totalPrice = 1.obs;

  List<double> eachPriceInCart = [];

  List<ProductVariantModel> listVariantInCart = [];

  List<ProductModel> listProduct = [];

  List<int> listQuantity = [];

  //get cart list vao bien de chia se vs wiget
  Future<List<ProductVariantModel>> getCartList() async {
    final listCart = await UserRepository.instance.getUserCart();
    List<ProductVariantModel> productVariantList = [];
    if (listCart != null && listCart.isNotEmpty) {
      await Future.forEach(listCart, (entry) async {
        await Future.wait(entry.keys.map((key) async {
          ProductVariantModel productVariantModel =
              await ProductVariantRepository.instance.getVariantById(key);
          ProductModel? productModel =
              await ProductRepository.instance.getProductByVariantId(key);
          listProduct.add(productModel!);
          productVariantList.add(productVariantModel);
          listVariantInCart.add(productVariantModel);
          listQuantity.add(entry[key]!);
          eachPriceInCart.add(entry[key]! * productVariantModel.price);
        }));
      });
    }
    updateTotalAmount();
    return productVariantList;
  }
}
