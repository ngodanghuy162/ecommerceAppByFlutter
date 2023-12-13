import 'package:ecommerce_app_mobile/common/styles/shadows.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_app_mobile/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_app_mobile/common/widgets/texts/product_price_text.dart';
import 'package:ecommerce_app_mobile/common/widgets/texts/product_title_text.dart';
import 'package:ecommerce_app_mobile/common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_variant_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_details/product_detail_screen.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TProductCardVertical extends StatelessWidget {
  TProductCardVertical(
      {super.key,
      this.product,
      this.brand,
      this.isProductVariant = true,
      this.listProduct});

  final variantController = Get.put(ProductVariantController());
  final productController = Get.put(ProductController());

  final ProductModel? product;
  final BrandModel? brand;
  final bool isProductVariant;
  final List<dynamic>? listProduct;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return isProductVariant
        ? FutureBuilder(
            future: variantController.getVariantByIDs(product!.variants_path!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<ProductVariantModel> listVariants = snapshot.data!;
                  var minPrice = double.infinity, maxPrice = 0.0;
                  for (var e in listVariants) {
                    minPrice = e.price < minPrice ? e.price : minPrice;
                    maxPrice = e.price > maxPrice ? e.price : maxPrice;
                  }
                  return GestureDetector(
                    onTap: () => Get.to(() => ProductDetailScreen(
                          listVariants: listVariants,
                          product: product!,
                          brand: brand,
                        )),
                    child: Container(
                      width: 180,
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          boxShadow: [TShadowStyle.verticalProductShadow],
                          borderRadius:
                              BorderRadius.circular(TSizes.productImageRadius),
                          color: dark ? TColors.darkerGrey : TColors.white),
                      child: Column(children: [
                        // Thumbnail, Wishlist, Button, Discount Tag
                        TRoundedContainer(
                          height: 180,
                          padding: const EdgeInsets.all(TSizes.sm),
                          backgroundColor: dark ? TColors.dark : TColors.light,
                          child: Stack(children: [
                            // -- Thumbnail Image
                            const TRoundedImage(
                              imageUrl: TImages.productImage1,
                              applyImageRadius: true,
                            ),

                            // -- Sale Tag
                            Positioned(
                              top: 12,
                              child: TRoundedContainer(
                                radius: TSizes.sm,
                                backgroundColor:
                                    TColors.secondary.withOpacity(0.8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: TSizes.sm, vertical: TSizes.xs),
                                child: Text(
                                    '${product!.discount!}%', //TODO query and add
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .apply(
                                          color: TColors.black,
                                        )),
                              ),
                            ),
                            // -- Favourite Button
                            const Positioned(
                              top: 0,
                              right: 0,
                              child: TCircularIcon(
                                icon: Iconsax.heart5,
                                color: Colors.red,
                              ),
                            ),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: TSizes.sm),
                          child: Column(children: [
                            TProductTitleText(
                              title: product!.name,
                              smallSize: true,
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems / 2),
                            TBrandTitleWithVerifiedIcon(
                                title: brand!.name,
                                showVerify: brand!.isVerified),
                          ]),
                        ),

                        const Spacer(),

                        /// Price Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// Price
                            Padding(
                              padding: const EdgeInsets.only(left: TSizes.sm),
                              child: TProductPriceText(
                                price: minPrice == maxPrice
                                    ? priceAfterDis(
                                        minPrice, product!.discount!)
                                    : " ${priceAfterDis(minPrice, product!.discount!)} - ${priceAfterDis(maxPrice, product!.discount!)}",
                              ),
                            ),
                            //add to cart button
                            Container(
                              decoration: const BoxDecoration(
                                  color: TColors.dark,
                                  borderRadius: BorderRadius.only(
                                    topLeft:
                                        Radius.circular(TSizes.cardRadiusMd),
                                    bottomRight: Radius.circular(
                                        TSizes.productImageRadius),
                                  )),
                              child: const SizedBox(
                                width: TSizes.iconLg * 1.2,
                                height: TSizes.iconLg * 1.2,
                                child: Center(
                                  child: Icon(
                                    Iconsax.add,
                                    color: TColors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ]),
                    ),
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
        : FutureBuilder(
            future: variantController.getAllProductVariants(product!.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<ProductVariantModel> listVariants = snapshot.data!;
                  var minPrice = double.infinity, maxPrice = 0.0;
                  for (var e in listVariants) {
                    minPrice = e.price < minPrice ? e.price : minPrice;
                    maxPrice = e.price > maxPrice ? e.price : maxPrice;
                  }
                  return GestureDetector(
                    onTap: () => Get.to(() => ProductDetailScreen(
                          listVariants: listVariants,
                          product: product!,
                          brand: brand,
                        )),
                    child: Container(
                      width: 180,
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          boxShadow: [TShadowStyle.verticalProductShadow],
                          borderRadius:
                              BorderRadius.circular(TSizes.productImageRadius),
                          color: dark ? TColors.darkerGrey : TColors.white),
                      child: Column(children: [
                        // Thumbnail, Wishlist, Button, Discount Tag
                        TRoundedContainer(
                          height: 180,
                          padding: const EdgeInsets.all(TSizes.sm),
                          backgroundColor: dark ? TColors.dark : TColors.light,
                          child: Stack(children: [
                            // -- Thumbnail Image
                            const TRoundedImage(
                              imageUrl: TImages.productImage1,
                              applyImageRadius: true,
                            ),

                            // -- Sale Tag
                            Positioned(
                              top: 12,
                              child: TRoundedContainer(
                                radius: TSizes.sm,
                                backgroundColor:
                                    TColors.secondary.withOpacity(0.8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: TSizes.sm, vertical: TSizes.xs),
                                child: Text('27%', //TODO query and add
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .apply(
                                          color: TColors.black,
                                        )),
                              ),
                            ),
                            // -- Favourite Button
                            const Positioned(
                              top: 0,
                              right: 0,
                              child: TCircularIcon(
                                icon: Iconsax.heart5,
                                color: Colors.red,
                              ),
                            ),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: TSizes.sm),
                          child: Column(children: [
                            TProductTitleText(
                              title: product!.name,
                              smallSize: true,
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems / 2),
                            TBrandTitleWithVerifiedIcon(
                                title: brand!.name,
                                showVerify: brand!.isVerified),
                          ]),
                        ),

                        const Spacer(),

                        /// Price Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// Price
                            Padding(
                              padding: const EdgeInsets.only(left: TSizes.sm),
                              child: TProductPriceText(
                                price: minPrice == maxPrice
                                    ? priceAfterDis(
                                        minPrice, product!.discount!)
                                    : " ${priceAfterDis(minPrice, product!.discount!)} - ${priceAfterDis(maxPrice, product!.discount!)}",
                              ),
                            ),
                            //add to cart button
                            Container(
                              decoration: const BoxDecoration(
                                  color: TColors.dark,
                                  borderRadius: BorderRadius.only(
                                    topLeft:
                                        Radius.circular(TSizes.cardRadiusMd),
                                    bottomRight: Radius.circular(
                                        TSizes.productImageRadius),
                                  )),
                              child: const SizedBox(
                                width: TSizes.iconLg * 1.2,
                                height: TSizes.iconLg * 1.2,
                                child: Center(
                                  child: Icon(
                                    Iconsax.add,
                                    color: TColors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ]),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: Text("smt went wrong"));
                }
              } else {
                return const CircularProgressIndicator();
              }
            });
  }
}

String priceAfterDis(double price, int discount) {
  double res = price * ((100 - discount) / 100);
  return res.toStringAsFixed(1);
}
