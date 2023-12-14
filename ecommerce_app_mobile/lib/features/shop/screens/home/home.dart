import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/primary_header_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/search_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ecommerce_app_mobile/common/widgets/texts/section_heading.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/home_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/brand_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_variant_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/detail_product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/all_products/all_products.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/home/widget/home_appbar.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/home/widget/home_categories.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/home/widget/promo_slider.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/colors.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final brandController = Get.put(BrandController());
  final productController = Get.put(ProductController());
  final variantController = Get.put(ProductVariantController());
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          /// Header
          TPrimaryHeaderContainer(
            child: Column(
              children: [
                /// -- Appbar
                const THomeAppBar(),
                const SizedBox(height: TSizes.spaceBtwSections),

                /// -- SearchBar
                const TSearchContainer(text: 'Search in Store'),
                const SizedBox(height: TSizes.spaceBtwSections),

                /// -- Categories
                Padding(
                  padding: const EdgeInsets.only(left: TSizes.defaultSpace),
                  child: Column(
                    children: [
                      /// -- Heading
                      const TSectionHeading(
                        title: 'Popular Categories',
                        showActionButton: false,
                        textColor: TColors.white,
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      /// Categories
                      THomeCategories(),
                    ],
                  ),
                ),

                const SizedBox(height: TSizes.spaceBtwSections),
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
                TSectionHeading(
                  title: "Popular Products",
                  onPressed: () {
                    Get.to(() => const AllProductsScreen());
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                FutureBuilder(
                    future: productController.getListPopularProduct(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          List<ProductModel> listProducts = snapshot.data!;
                          int lenghtShow = snapshot.data!.length > 4
                              ? 4
                              : snapshot.data!.length;
                          return TGridLayout(
                            itemCount: lenghtShow,
                            itemBuilder: (_, index) => FutureBuilder(
                                future: Future.wait([
                                  brandController.getBrandById(
                                      listProducts[index].brand_id),
                                  variantController.getVariantByIDs(
                                      listProducts[index].variants_path),
                                ]),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      var brand =
                                          snapshot.data![0] as BrandModel;
                                      var listVariants = snapshot.data![1]
                                          as List<ProductVariantModel>;
                                      return TProductCardVertical(
                                          modelDetail: DetailProductModel(
                                              brand: brand,
                                              product: listProducts[index],
                                              listVariants: listVariants));
                                      // return Container();
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text(snapshot.error.toString()));
                                    } else {
                                      return const Center(
                                          child: Text("smt went wrong"));
                                    }
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                }),
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        } else {
                          return const Center(child: Text("smt went wrong"));
                        }
                      } else {
                        return const CircularProgressIndicator();
                      }
                    })
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
