import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchControllerX extends GetxController {
  static SearchControllerX get instance => Get.find();

  bool isSearching = false;
  final TextEditingController keySearch = TextEditingController();

  RxString keySearchObs = ''.obs;

  List<String>? suggestedKeywords = [];

  @override
  void onInit() {
    isSearching = false;
    getSuggestList();
    super.onInit();
  }

  @override
  void onClose() {
    keySearch.text = '';
    isSearching = false;
    super.onClose();
  }

  void updateSearchKey() {
    keySearchObs.value = keySearch.text;
  }

  Future<void> getSuggestList() async {
    Get.put(ProductRepository());
    // Giả lập việc lấy dữ liệu từ một nguồn nào đó
    List<ProductModel> listPrd =
        await ProductRepository.instance.queryAllProducts();
    listPrd.forEach((product) {
      suggestedKeywords!.add(product.name);
    });
    print("Fetch list suggest oke");
    print(suggestedKeywords!.length);
    return;
  }
}
