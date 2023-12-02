import 'package:ecommerce_app_mobile/Controller/search_controller.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/search_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchingScreen extends StatelessWidget {
  final _searchControllerX = Get.put(SearchControllerX());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Screen'),
      ),
      body: Column(
        children: [
          TSearchContainer(text: _searchControllerX.keySearch.text),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: _searchControllerX.suggestedKeywords.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_searchControllerX.suggestedKeywords[index]),
                    onTap: () {
                      // Xử lý khi người dùng chọn từ khóa gợi ý
                      _searchControllerX.handleKeywordSelection(
                          _searchControllerX.suggestedKeywords[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
