import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:ecommerce_app_mobile/Controller/search_controller.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/search_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchingScreen extends StatelessWidget {
  SearchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SearchControllerX());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Suggest Screen'),
      ),
      body: FutureBuilder(
          future: SearchControllerX.instance.getSuggestList(),
          builder: (context, snapshot) {
            return Column(
              children: [
                Text(
                    "KeySearch + Suggest:${SearchControllerX.instance.keySearch.text}"),
                TSearchContainer(
                    text: SearchControllerX.instance.keySearch.text),
                Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: EasyAutocomplete(
                        suggestions:
                            SearchControllerX.instance.suggestedKeywords,
                        onChanged: (value) => print('onChanged value: $value'),
                        onSubmitted: (value) =>
                            print('onSubmitted value: $value'))),
                // Expanded(
                //   child: Obx(
                //     () => ListView.builder(
                //       itemCount: _searchControllerX.suggestedKeywords.length,
                //       itemBuilder: (context, index) {
                //         return ListTile(
                //           title: Text(_searchControllerX.suggestedKeywords[index]),
                //           onTap: () {
                //             // Xử lý khi người dùng chọn từ khóa gợi ý
                //             _searchControllerX.handleKeywordSelection(
                //                 _searchControllerX.suggestedKeywords[index]);
                //           },
                //         );
                //       },
                //     ),
                //   ),
                // ),
              ],
            );
          }),
    );
  }
}

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

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

  final TextEditingController _controller = TextEditingController();
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
            decoration: const InputDecoration(
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
