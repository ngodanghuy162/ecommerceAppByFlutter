import 'package:ecommerce_app_mobile/Controller/search_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/search/search_result_screen.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/search/search_sugges_screen.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/device/device_utility.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class TSearchContainer extends StatelessWidget {
  const TSearchContainer({
    super.key,
    required this.text,
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBorder = true,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
  });

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(SearchControllerX());
    final dark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Container(
          width: TDeviceUtils.getScreenWidth(context),
          padding: const EdgeInsets.all(TSizes.md),
          decoration: BoxDecoration(
            color: showBackground
                ? dark
                    ? TColors.dark
                    : TColors.light
                : Colors.transparent,
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            border: showBorder ? Border.all(color: TColors.grey) : null,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: onTap,
                child: IconButton(
                  icon: Icon(icon, color: TColors.darkerGrey),
                  onPressed: () {
                    if (SearchControllerX.instance.keySearch.text.isNotEmpty) {
                      searchController.isSearching = true;
                      SearchControllerX.instance.updateSearchKey();
                      Get.to(() => SearchResultScreen(
                            keySearch:
                                SearchControllerX.instance.keySearch.text,
                          ));
                    }
                  },
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: TextField(
                  controller: SearchControllerX.instance.keySearch,
                  decoration: InputDecoration(
                    hintText: 'Search in Store',
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                  ),
                  onTap: () {
                    if (Get.currentRoute.runtimeType != SearchingScreen ||
                        Get.currentRoute.runtimeType != SearchResultScreen) {
                      if (searchController.isSearching == false) {
                        searchController.isSearching == true;
                        print("Go to searching");
                        Get.to(() => const SearchingScreen());
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
