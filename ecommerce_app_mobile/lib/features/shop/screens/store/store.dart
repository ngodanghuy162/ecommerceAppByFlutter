import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/tabbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/brands/brand_card.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/search_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/cart_menu_icon.dart';
import 'package:ecommerce_app_mobile/common/widgets/texts/section_heading.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/brand_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/brand/all_brands.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/cart/cart.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/store/widgets/category_tab.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreScreen extends StatelessWidget {
  StoreScreen({super.key});

  final controllerBrand = Get.put(BrandController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: TAppBar(
          showBackArrow: false,
          title:
              Text('Store', style: Theme.of(context).textTheme.headlineMedium),
          actions: [
            TCartCounterIcon(
              onPressed: () => Get.to(const CartScreen()),
              iconColor: null,
            )
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: THelperFunctions.isDarkMode(context)
                    ? TColors.black
                    : TColors.white,
                expandedHeight: 440,

                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      /// Search bar
                      const SizedBox(height: TSizes.spaceBtwItems),
                      const TSearchContainer(
                        text: 'Search in Store',
                        showBorder: true,
                        showBackground: false,
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      /// Featured Brands
                      TSectionHeading(
                        title: 'Featured Brands',
                        onPressed: () => Get.to(() => AllBrandsScreen()),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems / 1.5),
                      FutureBuilder(
                          future: controllerBrand.getAllBrandsData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                return TGridLayout(
                                  itemCount: snapshot.data!.length,
                                  mainAxisExtent: 80,
                                  itemBuilder: (_, index) {
                                    return TBrandCard(
                                      showVerify:
                                          snapshot.data![index].isVerified,
                                      showBorder: false,
                                      nameBrand: snapshot.data![index].name,
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text(snapshot.error.toString()));
                              } else {
                                return const Center(child: Text("Smt wrong!"));
                              }
                            } else {
                              return const CircularProgressIndicator();
                            }
                          })
                    ],
                  ),
                ),

                /// Tabs
                bottom: const TTabBar(
                  tabs: [
                    Tab(child: Text('Sport')),
                    Tab(child: Text('Furniture')),
                    Tab(child: Text('Electronics')),
                    Tab(child: Text('Clothes')),
                    Tab(child: Text('Cosmetics')),
                  ],
                ),
              ),
            ];
          },

          /// Body
          body: const TabBarView(
            children: [
              TCategoryTab(),
              TCategoryTab(),
              TCategoryTab(),
              TCategoryTab(),
              TCategoryTab(),
            ],
          ),
        ),
      ),
    );
  }
}
