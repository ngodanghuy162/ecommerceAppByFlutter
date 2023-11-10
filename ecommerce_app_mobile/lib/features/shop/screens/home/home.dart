import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/primary_header_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/search_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/texts/section_heading.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/home/widget/home_appbar.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/home/widget/home_categories.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          /// Header
          TPrimaryHeaderContainer(
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
          )),
        ],
      ),
    ));
  }
}
