import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/search_container.dart';
import 'package:flutter/material.dart';

class SearchingScreen extends StatelessWidget {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Screen'),
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TSearchContainer(text: "Con tiep o day")),
          Expanded(
            child: ListView(
              children: [
                // Hiển thị các dòng chữ gợi ý từ khóa
                ListTile(
                  title: Text('Gợi ý 1'),
                  onTap: () {
                    // Xử lý khi người dùng chọn từ khóa gợi ý
                  },
                ),
                ListTile(
                  title: Text('Gợi ý 2'),
                  onTap: () {
                    // Xử lý khi người dùng chọn từ khóa gợi ý
                  },
                ),
                // Thêm các ListTile khác tương tự cho các từ khóa khác
              ],
            ),
          ),
        ],
      ),
    );
  }
}
