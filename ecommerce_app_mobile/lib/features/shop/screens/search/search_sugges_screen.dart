import 'package:ecommerce_app_mobile/utils/device/device_utility.dart';
import 'package:searchfield/searchfield.dart';
import 'package:ecommerce_app_mobile/Controller/search_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/search/search_result_screen.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SearchingScreen extends StatelessWidget {
  const SearchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(SearchControllerX());
    // ignore: unused_local_variable
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Suggest Screen'),
      ),
      body: FutureBuilder(
        future: SearchControllerX.instance.getSuggestList(),
        builder: (context, snapshot) {
          // Check for data loading or error
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: Container(
                width: TDeviceUtils.getScreenWidth(context),
                padding: const EdgeInsets.all(TSizes.md),
                decoration: BoxDecoration(
                  color: true
                      ? dark
                          ? TColors.dark
                          : TColors.light
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                  border: true ? Border.all(color: TColors.grey) : null,
                ),
                child:
                    // Search input and submit button
                    Row(
                  children: [
                    IconButton(
                      icon: const Icon(Iconsax.search_normal,
                          color: TColors.darkerGrey),
                      onPressed: () {
                        if (searchController.keySearch.text.isNotEmpty) {
                          searchController.isSearching = true;
                          SearchControllerX.instance.updateSearchKey();
                          Get.to(() => SearchResultScreen(
                                keySearch: searchController.keySearch.text,
                              ));
                        }
                      },
                    ),
                    // Autocomplete text field
                    Expanded(
                      child: SearchField(
                        suggestions: SearchControllerX
                            .instance.suggestedKeywords!
                            .map((e) => SearchFieldListItem(e))
                            .toList(),
                        controller: searchController.keySearch,
                        suggestionState: Suggestion.expand,
                        textInputAction: TextInputAction.next,
                        suggestionsDecoration: SuggestionDecoration(
                            padding: const EdgeInsets.all(10),
                            color: dark
                                ? Color.fromARGB(255, 36, 34, 34)
                                : Color.fromARGB(255, 252, 248, 247),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        maxSuggestionsInViewPort: 10,
                        itemHeight: 50,
                        onSuggestionTap: (SearchFieldListItem<dynamic> a) {
                          // print(a.item);
                          // print(a.searchKey);
                          // return a;
                          Get.to(
                              () => SearchResultScreen(keySearch: a.searchKey));
                        },
                      ),
                    ),
                  ],
                ),
              )
              // Display key search + suggested keywords

              );
        },
      ),
    );
  }
}
