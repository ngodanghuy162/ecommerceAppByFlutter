// ignore_for_file: prefer_const_constructors

import 'package:ecommerce_app_mobile/common/widgets/brands/brand_show_case.dart';
import 'package:ecommerce_app_mobile/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ecommerce_app_mobile/common/widgets/texts/section_heading.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/brand_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_category_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_variant_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/detail_product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/category/category_products.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TCategoryTab extends StatelessWidget {
  TCategoryTab({super.key, required this.topic});
  final String topic;

  final categoriesController = Get.put(ProductCategoryController());
  final brandController = Get.put(BrandController());
  final productController = Get.put(ProductController());
  final variantController = Get.put(ProductVariantController());

  @override
  Widget build(BuildContext context) {
    categoriesController.choosedCategories.value = topic;

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// -- Brands
              FutureBuilder(
                  future: categoriesController.getCategoryDocumentIdByName(
                      categoriesController.choosedCategories.value),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        String categoryID = snapshot.data as String;
                        return FutureBuilder(
                            future: productController
                                .getProductByCategory(categoryID),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  List<ProductModel> listProducts =
                                      snapshot.data!;
                                  int lenghtShow = snapshot.data!.length > 4
                                      ? 4
                                      : snapshot.data!.length;
                                  return Column(
                                    children: [
                                      FutureBuilder(
                                          future: Future.wait([
                                            brandController.getBrandById(
                                                listProducts[0].brand_id),
                                            brandController.getBrandById(
                                                listProducts[1].brand_id),
                                            variantController.getVariantByIDs(
                                                listProducts[0].variants_path),
                                            variantController.getVariantByIDs(
                                                listProducts[1].variants_path),
                                          ]),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              if (snapshot.hasData) {
                                                BrandModel brand1 = snapshot
                                                    .data![0] as BrandModel;
                                                BrandModel brand2 = snapshot
                                                    .data![1] as BrandModel;
                                                List<ProductVariantModel>
                                                    variant1 =
                                                    snapshot.data![2] as List<
                                                        ProductVariantModel>;
                                                List<ProductVariantModel>
                                                    variant2 =
                                                    snapshot.data![3] as List<
                                                        ProductVariantModel>;

                                                return Column(
                                                  children: [
                                                    TBrandShowcase(
                                                      brand: brand1,
                                                      listVariant: variant1,
                                                    ),
                                                    TBrandShowcase(
                                                      brand: brand2,
                                                      listVariant: variant2,
                                                    ),
                                                    const SizedBox(
                                                      height:
                                                          TSizes.spaceBtwItems,
                                                    ),
                                                  ],
                                                );
                                              } else if (snapshot.hasError) {
                                                return Center(
                                                    child: Text(snapshot.error
                                                        .toString()));
                                              } else {
                                                return Center(
                                                    child:
                                                        Text("smt went wrong"));
                                              }
                                            } else {
                                              return const CircularProgressIndicator();
                                            }
                                          }),

                                      /// -- Products
                                      TSectionHeading(
                                        title: 'You might like',
                                        showActionButton: true,
                                        onPressed: () => Get.to(() =>
                                            CategoryProducts(
                                                listCategories:
                                                    categoriesController
                                                        .listCategoryProducts)),
                                      ),
                                      const SizedBox(
                                          height: TSizes.spaceBtwItems),
                                      TGridLayout(
                                        itemCount: lenghtShow,
                                        itemBuilder: (_, index) =>
                                            FutureBuilder(
                                                future: Future.wait([
                                                  brandController.getBrandById(
                                                      listProducts[index]
                                                          .brand_id),
                                                  variantController
                                                      .getVariantByIDs(
                                                          listProducts[index]
                                                              .variants_path),
                                                ]),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    if (snapshot.hasData) {
                                                      var brand =
                                                          snapshot.data![0]
                                                              as BrandModel;
                                                      var listVariants = snapshot
                                                              .data![1]
                                                          as List<
                                                              ProductVariantModel>;
                                                      brandController.listBrand
                                                          .add(brand);
                                                      DetailProductModel model =
                                                          DetailProductModel(
                                                              brand: brand,
                                                              product:
                                                                  listProducts[
                                                                      index],
                                                              listVariants:
                                                                  listVariants);
                                                      categoriesController
                                                          .listCategoryProducts
                                                          .add(model);
                                                      return TProductCardVertical(
                                                        modelDetail: model,
                                                      );
                                                      // return Container();
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Center(
                                                          child: Text(snapshot
                                                              .error
                                                              .toString()));
                                                    } else {
                                                      return const Center(
                                                          child: Text(
                                                              "smt went wrong"));
                                                    }
                                                  } else {
                                                    return const CircularProgressIndicator();
                                                  }
                                                }),
                                      ),
                                    ],
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text(snapshot.error.toString()));
                                } else {
                                  return const Center(
                                      child: Text("smt went wrong"));
                                }
                              } else {
                                return const CircularProgressIndicator();
                              }
                            });
                      } else if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      } else {
                        return const Center(
                            child: const Text("smt went wrong"));
                      }
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ],
    );
  }
}
