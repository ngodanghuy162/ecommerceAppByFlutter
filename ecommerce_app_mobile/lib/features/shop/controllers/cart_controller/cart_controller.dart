import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/shop_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_repository.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_variant_repository.dart';
import 'package:ecommerce_app_mobile/repository/shop_repository/shop_repository.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  RxInt numberOfShop = 1.obs;

  //RxList<int> listNumberProductInOneShop = <int>[].obs;

  List<RxInt> listSizeProductInShop = [];

  RxDouble totalAmount = 0.0.obs;

  Map<String, Map<String, int>> chooSenShopAndProduct = {};

  ProductVariantModel? chosenVariant;

  RxInt chosenShopInex = 0.obs;

  List<int> chosenIndex = [];

  // List<List<double>> listPrice = [];

  List<List<ProductVariantModel>> listVariant = [];

  List<ShopModel> listShop = [];

  List<List<ProductModel>> listProduct = [];

  List<List<int>> listQuantity = [];

  //get cart list vao bien de chia se vs wiget
  Future<bool> getCartList() async {
    Get.put(ShopRepository());
    final listCart = await UserRepository.instance.getUserCart();
    numberOfShop.value = (listCart == null) ? 0 : listCart.length;
    //listNumberProductInOneShop = <int>[].obs;
    listSizeProductInShop = [];
    listProduct = [];
    listQuantity = [];
    // listPrice = [];
    listVariant = [];
    listShop = [];
    if (listCart != null && listCart.isNotEmpty) {
      await Future.forEach(listCart, (entry) async {
        //tao cac list ung voi mo ishop moi vong lap
        List<ProductVariantModel> listVariantTMp = [];
        List<double> ecchPriceTmp = [];
        List<ProductModel> listProductTmp = [];
        List<int> listQuantityTmp = [];
        //moi vong lap lay 1 shop model ra
        final shopModel =
            await ShopRepository.instance.getShopByEmail(entry["shopemail"]);
        listShop.add(shopModel);

        await Future.forEach(entry["listvariant"].keys, (dynamic key) async {
          dynamic value = entry["listvariant"][key];

          ProductVariantModel productVariantModel =
              await ProductVariantRepository.instance.getVariantById(key);
          ProductModel? productModel =
              await ProductRepository.instance.getProductByVariantId(key);
          listProductTmp.add(productModel!);
          listVariantTMp.add(productVariantModel);
          listQuantityTmp.add(value);
          // ecchPriceTmp.add(value * productVariantModel.price);
        });
        listSizeProductInShop.add(listProductTmp.length.obs);
       // listNumberProductInOneShop.add(listProductTmp.length);
        listProduct.add(listProductTmp);
        listQuantity.add(listQuantityTmp);
        listVariant.add(listVariantTMp);
        // listPrice.add(ecchPriceTmp);
      });
    }
    return true;
  }

  addChoosenListByIndexProduct(int indexInCart, int indexInShop) {
    // Example of adding a key-value pair to your map
    String key = listShop[indexInCart].owner;
    Map<String, int> value = {
      listVariant[indexInCart][indexInShop].id!: listQuantity[indexInCart]
          [indexInShop]
    };
    if (!chooSenShopAndProduct.containsKey(key)) {
      Map<String, Map<String, int>> tmp = {key: value};
      chooSenShopAndProduct.addAll(tmp);
    } else {
      chooSenShopAndProduct[key]!.addAll(value);
    }
    totalAmount.value += listVariant[indexInCart][indexInShop].price *
        listQuantity[indexInCart][indexInShop];
  }

  deleteChoosenListByIndexProduct(int indexInCart, int indexInShop) {
    // Example of adding a key-value pair to your map
    String keyShop = listShop[indexInCart].owner;
    if (chooSenShopAndProduct.containsKey(keyShop)) {
      if (chooSenShopAndProduct[keyShop]!
          .containsKey(listVariant[indexInCart][indexInShop].id!)) {
        totalAmount.value -= listVariant[indexInCart][indexInShop].price *
            listQuantity[indexInCart][indexInShop];
        print("Da tru");
        chooSenShopAndProduct[keyShop]!
            .remove(listVariant[indexInCart][indexInShop].id!);
        if (chooSenShopAndProduct[keyShop]!.isEmpty) {
          chooSenShopAndProduct.remove(keyShop);
        }
      }
    }
  }

  //them vao ds da chon bang shop email + variant id + quantity
  addChoosenListByVariantId(String shopEmail, String variantId, int quantity) {
    // Example of adding a key-value pair to your map
    String keyShop = shopEmail;
    Map<String, int> value = {variantId: quantity};
    if (chooSenShopAndProduct.containsKey(keyShop)) {
      chooSenShopAndProduct[keyShop]!.addIf(true, variantId, quantity);
    } else {
      chooSenShopAndProduct[keyShop]!.addAll(value);
    }
  }

//them vao ds da chon bang shop email + variant id
  deleteChoosenListByVariantId(String shopEmail, String variantId) {
    // Example of adding a key-value pair to your map
    String keyShop = shopEmail;
    if (chooSenShopAndProduct.containsKey(keyShop)) {
      if (chooSenShopAndProduct.containsKey(keyShop)) {
        chooSenShopAndProduct[keyShop]!.remove(variantId);
        if (chooSenShopAndProduct[keyShop]!.isEmpty) {
          chooSenShopAndProduct.remove(keyShop);
        }
      }
    }
  }

  addChoosenListClickShop(int indexInCart) {
    for (int i = 0; i < listVariant[indexInCart].length; i++) {
      deleteChoosenListByIndexProduct(indexInCart, i);
    }
    int size = listProduct[indexInCart].length;
    for (int i = 0; i < size; i++) {
      // chooSenShopAndProduct[shopKey]![listVariant[indexInCart][i].id!] =
      //     listQuantity[indexInCart][i];
      addChoosenListByIndexProduct(indexInCart, i);
    }
  }

  deleteChoosenListClickShop(int indexInCart) {
    for (int i = 0; i < listVariant[indexInCart].length; i++) {
      deleteChoosenListByIndexProduct(indexInCart, i);
    }
  }

  updateTotalAmount(int indexInCart, int indexInShop, bool isAdd) {
    if (chooSenShopAndProduct.containsKey(listShop[indexInCart].owner)) {
      String keyShop = listShop[indexInCart].owner;
      if (chooSenShopAndProduct[keyShop]!
          .containsKey(listVariant[indexInCart][indexInShop].id)) {
        if (isAdd) {
          totalAmount.value += listVariant[indexInCart][indexInShop].price;
        } else {
          totalAmount.value -= listVariant[indexInCart][indexInShop].price;
        }
      }
    }
  }

  bool isShopChecked(int indexInCart) {
    if (chooSenShopAndProduct.containsKey(listShop[indexInCart].owner)) {
      return false;
    }
    if (chooSenShopAndProduct[listShop[indexInCart].owner]!.isEmpty) {
      return false;
    }
    int sizeShop = listProduct[indexInCart].length;
    int sizeChosen = chooSenShopAndProduct[listShop[indexInCart].owner]!.length;
    return (sizeChosen == sizeShop);
  }
  // getTotalPrice() {
  //   totalAmount.value++;
  // }
}
