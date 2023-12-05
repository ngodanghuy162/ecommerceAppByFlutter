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
          Text("KeySearch:" + SearchControllerX.instance.keySearch.text),
          TSearchContainer(text: SearchControllerX.instance.keySearch.text),
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

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final List<String> suggestions = [
    "Channel",
    "CodingLab",
    "CodingNepal",
    "YouTube",
    "YouTuber",
    "YouTube Channel",
    "Blogger",
    "Bollywood",
    "Vlogger",
    "Vechiles",
    "Facebook",
    "Freelancer",
    "Facebook Page",
    "Designer",
    "Developer",
    "Web Designer",
    "Web Developer",
    "Login Form in HTML & CSS",
    "How to learn HTML & CSS",
    "How to learn JavaScript",
    "How to became Freelancer",
    "How to became Web Designer",
    "How to start Gaming Channel",
    "How to start YouTube Channel",
    "What does HTML stands for?",
    "What does CSS stands for?",
  ];

  TextEditingController _controller = TextEditingController();
  List<String> _filteredSuggestions = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            onChanged: (value) {
              filterSuggestions(value);
            },
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredSuggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_filteredSuggestions[index]),
                onTap: () {
                  // Handle item selection here
                  print("Selected: ${_filteredSuggestions[index]}");
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void filterSuggestions(String query) {
    setState(() {
      _filteredSuggestions = suggestions
          .where((suggestion) =>
              suggestion.toLowerCase().startsWith(query.toLowerCase()))
          .toList();
    });
  }
}
