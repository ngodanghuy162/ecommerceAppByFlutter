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
    getSuggestList();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    print("on close");
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

  // Hàm cập nhật danh sách từ khóa gợi ý
  // void updateSuggestedKeywords(String keySearch) {
  //   // Thực hiện logic cập nhật danh sách từ khóa gợi ý dựa trên keySearch
  //   // Ở đây, bạn có thể sử dụng một logic phức tạp hơn, ví dụ: gọi API để lấy từ khóa gợi ý
  //   suggestedKeywords.assignAll(generateSuggestedKeywords(keySearch));
  // }

  // Hàm xử lý khi người dùng chọn từ khóa gợi ý
  void handleKeywordSelection(String selectedKeyword) {
    // Thực hiện xử lý khi người dùng chọn từ khóa gợi ý
    print('Selected Keyword: $selectedKeyword');
  }

  // Hàm tạo danh sách từ khóa gợi ý (ví dụ đơn giản)
  // List<String> generateSuggestedKeywords(String keySearch) {
  //   // Ở đây, bạn có thể sử dụng một logic phức tạp hơn để tạo danh sách từ khóa gợi ý
  //   // Ví dụ đơn giản: Trả về một danh sách từ khóa tạm thời
  //   return [
  //     '$keySearch suggestion 1',
  //     '$keySearch suggestion 2',
  //     // Thêm các từ khóa gợi ý khác tương tự
  //   ];
  // }
}
