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

class SearchingScreen extends StatefulWidget {
  SearchingScreen({super.key});
  final searchController = Get.put(SearchControllerX());
  @override
  State<SearchingScreen> createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {
  @override
  void dispose() {
    super.dispose();
    widget.searchController.keySearch.text = '';
    widget.searchController.isSearching = false;
    widget.searchController.keySearchObs.value = '';
  }

  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(SearchControllerX());
    // ignore: unused_local_variable
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
        appBar: AppBar(),
        body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
            child: Container(
              width: TDeviceUtils.getScreenWidth(context),
              padding: const EdgeInsets.all(TSizes.md),
              decoration: BoxDecoration(
                color: dark ? TColors.dark : TColors.light,
                borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                border: Border.all(color: TColors.grey),
              ),
              child: Row(
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
                  Expanded(
                    child: SearchField(
                      suggestions: SearchControllerX.instance.suggestedKeywords!
                          .map((e) => SearchFieldListItem(e))
                          .toList(),
                      controller: searchController.keySearch,
                      suggestionState: Suggestion.expand,
                      textInputAction: TextInputAction.next,
                      suggestionsDecoration: SuggestionDecoration(
                          padding: const EdgeInsets.all(10),
                          color: dark
                              ? const Color.fromARGB(255, 50, 48, 48)
                              : const Color.fromARGB(255, 252, 248, 247),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      maxSuggestionsInViewPort: 10,
                      itemHeight: 50,
                      onSuggestionTap: (SearchFieldListItem<dynamic> a) {
                        Get.to(
                            () => SearchResultScreen(keySearch: a.searchKey));
                      },
                    ),
                  ),
                ],
              ),
            )));
  }
}
