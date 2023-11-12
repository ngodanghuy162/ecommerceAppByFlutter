import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/primary_header_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/search_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ecommerce_app_mobile/common/widgets/texts/section_heading.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/home/widget/home_appbar.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/home/widget/home_categories.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/home/widget/promo_slider.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          /// Header
          const TPrimaryHeaderContainer(
            child: Column(
              children: [
                /// -- Appbar
                THomeAppBar(),
                SizedBox(height: TSizes.spaceBtwSections),

                /// -- SearchBar
                TSearchContainer(text: 'Search in Store'),
                SizedBox(height: TSizes.spaceBtwSections),

                /// -- Categories
                Padding(
                  padding: EdgeInsets.only(left: TSizes.defaultSpace),
                  child: Column(
                    children: [
                      /// -- Heading
                      TSectionHeading(
                        title: 'Popular Categories',
                        showActionButton: false,
                        textColor: TColors.white,
                      ),
                      SizedBox(height: TSizes.spaceBtwItems),

                      /// Categories
                      THomeCategories(),
                    ],
                  ),
                )
              ],
            ),
          ),

          /// Body
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                const TPromoSlider(banners: [
                  TImages.promoBanner1,
                  TImages.promoBanner2,
                  TImages.promoBanner3
                ]),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),

                /// -- Heading
                TSectionHeading(title: "Popular Products", onPressed: () {}),
                const SizedBox(height: TSizes.spaceBtwItems),

                TGridLayout(
                  itemCount: 4,
                  itemBuilder: (_, index) => const TProductCardVertical(),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
