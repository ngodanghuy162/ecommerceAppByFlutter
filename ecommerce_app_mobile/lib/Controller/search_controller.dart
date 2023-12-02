import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SearchControllerX extends GetxController {
  static SearchControllerX get instance => Get.find();
  RxBool isSearching = false.obs;
  final keySearch = TextEditingController();
  RxList<String> suggestedKeywords = <String>[].obs;

  // Hàm cập nhật danh sách từ khóa gợi ý
  void updateSuggestedKeywords(String keySearch) {
    // Thực hiện logic cập nhật danh sách từ khóa gợi ý dựa trên keySearch
    // Ở đây, bạn có thể sử dụng một logic phức tạp hơn, ví dụ: gọi API để lấy từ khóa gợi ý
    suggestedKeywords.assignAll(generateSuggestedKeywords(keySearch));
  }

  // Hàm xử lý khi người dùng chọn từ khóa gợi ý
  void handleKeywordSelection(String selectedKeyword) {
    // Thực hiện xử lý khi người dùng chọn từ khóa gợi ý
    print('Selected Keyword: $selectedKeyword');
  }

  // Hàm tạo danh sách từ khóa gợi ý (ví dụ đơn giản)
  List<String> generateSuggestedKeywords(String keySearch) {
    // Ở đây, bạn có thể sử dụng một logic phức tạp hơn để tạo danh sách từ khóa gợi ý
    // Ví dụ đơn giản: Trả về một danh sách từ khóa tạm thời
    return [
      '$keySearch suggestion 1',
      '$keySearch suggestion 2',
      // Thêm các từ khóa gợi ý khác tương tự
    ];
  }
}
