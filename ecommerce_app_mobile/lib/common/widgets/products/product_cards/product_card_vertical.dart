import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/common/styles/shadows.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_app_mobile/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_app_mobile/common/widgets/texts/product_price_text.dart';
import 'package:ecommerce_app_mobile/common/widgets/texts/product_title_text.dart';
import 'package:ecommerce_app_mobile/common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_variant_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/detail_product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_details/product_detail_screen.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TProductCardVertical extends StatefulWidget {
  const TProductCardVertical({super.key, required this.modelDetail});

  final DetailProductModel modelDetail;

  @override
  State<TProductCardVertical> createState() => _TProductCardVerticalState();
}

class _TProductCardVerticalState extends State<TProductCardVertical> {
  RxBool isInWishlist = false.obs;

  final variantController = Get.put(ProductVariantController());

  final productController = Get.put(ProductController());

  final userController = Get.put(UserRepository());

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    List<ProductVariantModel> listVariants = widget.modelDetail.listVariants;
    var minPrice = double.infinity, maxPrice = 0.0;
    for (var e in listVariants) {
      minPrice = e.price < minPrice ? e.price : minPrice;
      maxPrice = e.price > maxPrice ? e.price : maxPrice;
    }
    return FutureBuilder(
        future: UserRepository.instance
            .isProductInWishList(widget.modelDetail.product),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            isInWishlist.value = snapshot.data as bool;
            return GestureDetector(
              onTap: () => Get.to(() => ProductDetailScreen(
                    listVariants: widget.modelDetail.listVariants,
                    product: widget.modelDetail.product,
                    brand: widget.modelDetail.brand,
                  )),
              child: Container(
                width: 180,
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                    boxShadow: [TShadowStyle.verticalProductShadow],
                    borderRadius:
                        BorderRadius.circular(TSizes.productImageRadius),
                    color: dark ? TColors.darkerGrey : TColors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thumbnail, Wishlist, Button, Discount Tag
                    TRoundedContainer(
                      height: 180,
                      padding: const EdgeInsets.all(TSizes.sm),
                      backgroundColor: dark ? TColors.dark : TColors.light,
                      child: Stack(
                        children: [
                          // -- Thumbnail Image
                          Center(
                            child: TRoundedImage(
                              imageUrl:
                                  widget.modelDetail.listVariants[0].imageURL,
                              applyImageRadius: true,
                              isNetworkImage: true,
                            ),
                          ),

                          // -- Sale Tag
                          Positioned(
                            top: 10,
                            child: TRoundedContainer(
                              radius: TSizes.sm,
                              backgroundColor:
                                  TColors.secondary.withOpacity(0.8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: TSizes.sm, vertical: TSizes.xs),
                              child: Text(
                                  '${widget.modelDetail.product.discount!}%',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .apply(
                                        color: TColors.black,
                                      )),
                            ),
                          ),
                          // -- Favourite Button

                          Positioned(
                            top: 0,
                            right: 0,
                            child: Obx(
                              () => TCircularIcon(
                                onPressed: () async {
                                  await userController
                                      .addOrRemoveProductToWishlist(
                                          widget.modelDetail.product);
                                  isInWishlist.value = !isInWishlist.value;
                                },
                                icon: isInWishlist.value
                                    ? Iconsax.heart5
                                    : Iconsax.heart_add,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: TSizes.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TProductTitleText(
                            title: widget.modelDetail.product.name,
                            smallSize: true,
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems / 2),
                          TBrandTitleWithVerifiedIcon(
                            title: widget.modelDetail.brand.name,
                            showVerify: widget.modelDetail.brand.isVerified,
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    /// Price Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Price
                        Container(
                          padding: const EdgeInsets.only(left: TSizes.sm),
                          child: TProductPriceText(
                            price: minPrice == maxPrice
                                ? priceAfterDis(minPrice,
                                    widget.modelDetail.product.discount!)
                                : " ${priceAfterDis(minPrice, widget.modelDetail.product.discount!)} - ${priceAfterDis(maxPrice, widget.modelDetail.product.discount!)}",
                          ),
                        ),
                        //add to cart button
                        Container(
                          decoration: const BoxDecoration(
                            color: TColors.dark,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(TSizes.cardRadiusMd),
                              bottomRight:
                                  Radius.circular(TSizes.productImageRadius),
                            ),
                          ),
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
                  ],
                ),
              ),
            );
          } else {
            return Container(
              height: THelperFunctions.screenHeight(),
              alignment: Alignment.center,
              child:
                  const CircularProgressIndicator(), // you can add pre loader iamge as well to show loading.
            );
          }
        });
  }
}

String priceAfterDis(double price, int discount) {
  double res = price * ((100 - discount) / 100);
  return res.toStringAsFixed(1);
}
