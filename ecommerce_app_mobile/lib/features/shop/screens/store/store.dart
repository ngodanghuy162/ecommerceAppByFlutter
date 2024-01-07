import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/tabbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/brands/brand_card.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/search_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/cart/cart_menu_icon.dart';

import 'package:ecommerce_app_mobile/common/widgets/texts/section_heading.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/brand_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/brand/all_brands.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/brand/brand_products.dart';
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
      length: 8,
      child: Scaffold(
        appBar: TAppBar(
          showBackArrow: false,
          title:
              Text('Store', style: Theme.of(context).textTheme.headlineMedium),
          actions: [
            TCartCounterIcon(
              onPressed: () => Get.to(CartScreen()),
              iconColor: TColors.black,
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
                expandedHeight: 460,

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
                                List<BrandModel> listProducts = snapshot.data!;
                                listProducts
                                    .sort(((a, b) => a.name.compareTo(b.name)));
                                listProducts.sort((a, b) {
                                  if (a.isVerified && !b.isVerified) {
                                    return -1; // Put completed objects first
                                  } else if (!a.isVerified && b.isVerified) {
                                    return 1; // Put non-completed objects last
                                  }
                                  return 0; // Equal
                                });
                                return TGridLayout(
                                  itemCount: 4,
                                  mainAxisExtent: 80,
                                  itemBuilder: (_, index) {
                                    return TBrandCard(
                                      showBorder: true,
                                      brand: snapshot.data![index],
                                      onTap: () {
                                        Get.to(() => BrandProducts(
                                            brand: snapshot.data![index]));
                                      },
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
                    Tab(child: Text('Clothes')),
                    Tab(child: Text('Cosmetics')),
                    Tab(child: Text('Electronics')),
                    Tab(child: Text('Furniture')),
                    Tab(child: Text('Jewelery')),
                    Tab(child: Text('Shoe')),
                    Tab(child: Text('Sport')),
                    Tab(child: Text('Toy')),
                  ],
                ),
              ),
            ];
          },

          /// Body
          body: TabBarView(
            children: [
              TCategoryTab(topic: 'Clothes'),
              TCategoryTab(topic: 'Cosmetics'),
              TCategoryTab(topic: 'Electronics'),
              TCategoryTab(topic: 'Furniture'),
              TCategoryTab(topic: 'Jewelery'),
              TCategoryTab(topic: 'Shoe'),
              TCategoryTab(topic: 'Sport'),
              TCategoryTab(topic: 'Toy'),
            ],
          ),
        ),
      ),
    );
  }
}
