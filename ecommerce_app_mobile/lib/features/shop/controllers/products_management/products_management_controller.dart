import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_category_repository.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_repository.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_variant_repository.dart';
import 'package:ecommerce_app_mobile/repository/shop_repository/shop_repository.dart';
import 'package:get/get.dart';

class ProductsManagementController extends GetxController {
  static ProductsManagementController get instance => Get.find();
  final productCategoryRepository = Get.put(ProductCategoryRepository());
  final shopRepository = Get.put(ShopRepository());
  final productRepository = Get.put(ProductRepository());
  final productVariantRepository = Get.put(ProductVariantRepository());
  RxList<dynamic> categoryList = [].obs;

  final RxString currentCategory = ''.obs;
  final RxString status = 'Name'.obs;
  final RxList<dynamic> productList = [].obs;

  @override
  void onReady() async {
    super.onReady();
    await updateCategoryList();
  }

  getProductList() {
    return productList
        .where((p0) =>
            (p0 as ProductModel).product_category_id == currentCategory.value)
        .toList();
  }

  sortProductList() async {
    if (status.value == 'Name') {
      productList.sort(((a, b) => a.name.compareTo(b.name)));
    } else if (status.value == 'Higher Price') {
    } else if (status.value == 'Lower Price') {
    } else if (status.value == 'Sale') {
      productList.sort(((a, b) => b.discount!.compareTo(a.discount!)));
    }
  }

  Future<void> updateCategoryList() async {
    do {
      await shopRepository.updateShopDetails();
    } while (shopRepository.currentShopModel == null);

    // shopRepository.currentShopModel!.owner
    final productCategoryList =
        await productCategoryRepository.getCategoriesByShopEmail(
      shopRepository.currentShopModel!.owner,
      (List<ProductModel> list) {
        productList.value = List.from(list);
      },
    );
    categoryList.value = productCategoryList
        .map(
          (e) => {'id': e.id, 'name': e.name},
        )
        .toList();
    currentCategory.value = categoryList.value.first['id'];
  }
}
