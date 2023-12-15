import 'dart:math';

import 'package:ecommerce_app_mobile/Service/Model/product_review_model/product_review_model.dart';
import 'package:ecommerce_app_mobile/common/styles/section_heading.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/brand_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_review_controller/product_review_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_details/widgets/bottom_add_to_cart_widget.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_details/widgets/product_attributes.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_details/widgets/rating_share_widget.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_reviews/product_reviews.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen(
      {super.key,
      required this.product,
      required this.brand,
      required this.listVariants});
  final ProductModel product;
  final BrandModel brand;
  final List<ProductVariantModel> listVariants;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final brandController = Get.put(BrandController());
  final productController = Get.put(ProductController());
  final reviewController = Get.put(ProductReviewController());

  @override
  Widget build(BuildContext context) {
    //final dark = THelperFunctions.isDarkMode(context);

    int indexCurrentVariant = 0;
    var minPrice = double.infinity, maxPrice = 0.0;
    int totalStock = 0;
    for (var variant in widget.listVariants) {
      minPrice = variant.price < minPrice ? variant.price : minPrice;
      maxPrice = variant.price > maxPrice ? variant.price : maxPrice;
      totalStock += variant.quantity;
    }

    return Scaffold(
      bottomNavigationBar: const TBottomAddToCart(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Product Image Slider
            TProductImageSlider(
              listVariant: widget.listVariants,
            ),

            /// Product Details
            Padding(
              padding: const EdgeInsets.only(
                  right: TSizes.defaultSpace,
                  left: TSizes.defaultSpace,
                  bottom: TSizes.defaultSpace),
              child: Column(
                children: [
                  /// Rating & Share Button
                  FutureBuilder(
                      future: productController.getReviewByProductID(widget.product.id!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            List<ProductReviewModel> reviewList = snapshot.data!;
                            List<double> starRating = [];

                            if(reviewList.isEmpty) {
                              return TRatingAndShare(
                                overall: 0,
                                reviewLength: reviewList.length,
                                variant: widget.listVariants[0],
                                product: widget.product,
                                maxPrice: maxPrice,
                                minPrice: minPrice,
                                discount: widget.product.discount!,
                              );
                            }

                            for (int i = 0; i < 5; i++) {
                              // số lần xuất hiện
                              double number = 0;
                              for (int j = 0; j < reviewList.length; j++) {
                                if (reviewList[j].rating == (i + 1).toDouble()) {
                                  number++;
                                }
                              }
                              double ratio = (number / reviewList.length).toDouble();
                              starRating.add(ratio);
                            }

                            double overall = 5 * starRating[4] +
                                4 * starRating[3] +
                                3 * starRating[2] +
                                2 * starRating[1] +
                                1 * starRating[0];

                            return TRatingAndShare(
                              overall: overall,
                              reviewLength: reviewList.length,
                              variant: widget.listVariants[0],
                              product: widget.product,
                              maxPrice: maxPrice,
                              minPrice: minPrice,
                              discount: widget.product.discount!,
                            );
                          } else if (snapshot.hasError) {
                            return Center(child: Text(snapshot.error.toString()));
                          }
                        }
                        return const CircularProgressIndicator();
                      }),

                  /// Price, Title, Stack & Brand
                  TProductMetaData(
                    isVerified: widget.brand.isVerified,
                    product: widget.product,
                    nameBrand: widget.brand.name,
                    maxPrice: maxPrice,
                    minPrice: minPrice,
                    discount: widget.product.discount!,
                    totalStock: totalStock,
                  ),

                  /// Attributes
                  TProductAttributes(
                    index: indexCurrentVariant,
                    listVariants: widget.listVariants,
                    product: widget.product,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  /// Checkout Button
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {}, child: const Text('Checkout'))),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  /// Description
                  const TSectionHeading(
                    title: 'Description',
                    showActionButton: false,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  ReadMoreText(
                    widget.product.description,
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' Show more',
                    trimExpandedText: ' Less',
                    moreStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                  ),

                  /// Reviews
                  const Divider(),
                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder(
                          future: productController
                              .getReviewByProductID(widget.product.id!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                return TSectionHeading(
                                  title: 'Reviews(${snapshot.data!.length})',
                                  showActionButton: false,
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
                          }),
                      IconButton(
                        icon: const Icon(
                          Iconsax.arrow_right_3,
                          size: 18,
                        ),
                        onPressed: () => Get.to(() => ProductReviewsScreen(
                              product: widget.product,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
