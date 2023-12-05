import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/search_container.dart';
import 'package:flutter/material.dart';

class SearchingScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  SearchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Screen'),
      ),
      body: Column(
        children: [
          const Padding(
              padding: EdgeInsets.all(8.0),
              child: TSearchContainer(text: "Con tiep o day")),
          Expanded(
            child: ListView(
              children: [
                // Hiển thị các dòng chữ gợi ý từ khóa
                ListTile(
                  title: const Text('Gợi ý 1'),
                  onTap: () {
                    // Xử lý khi người dùng chọn từ khóa gợi ý
                  },
                ),
                ListTile(
                  title: const Text('Gợi ý 2'),
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
