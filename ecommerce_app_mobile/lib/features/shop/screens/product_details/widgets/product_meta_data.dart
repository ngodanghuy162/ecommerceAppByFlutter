import 'package:ecommerce_app_mobile/common/styles/product_price_text.dart';
import 'package:ecommerce_app_mobile/common/styles/product_title_text.dart';
import 'package:ecommerce_app_mobile/common/styles/t_brand_title_text_with_verified_icon.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/images/t_circular_image.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_variant_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/enums.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TProductMetaData extends StatelessWidget {
  TProductMetaData({
    super.key,
    required this.nameBrand,
    required this.product,
    required this.maxPrice,
    required this.minPrice,
    required this.discount,
    this.isVerified = false,
    required this.totalStock,
  });

  final String nameBrand;
  final ProductModel product;
  final variantsController = Get.put(ProductVariantController());
  final double maxPrice;
  final double minPrice;
  final int discount;
  final bool isVerified;
  final int totalStock;

  @override
  Widget build(BuildContext context) {
    final darkMode = THelperFunctions.isDarkMode(context);

    return FutureBuilder(
        future: variantsController.getAllProductVariants(product.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Price & Sale price
                  Row(
                    children: [
                      TRoundedContainer(
                        radius: TSizes.sm,
                        backgroundColor: TColors.secondary.withOpacity(0.8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: TSizes.sm, vertical: TSizes.xs),
                        child: Text(
                          '${discount}%',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .apply(color: TColors.black),
                        ),
                      ),
                      const SizedBox(
                        width: TSizes.spaceBtwItems,
                      ),
                      Text(
                        minPrice == maxPrice
                            ? '$minPrice'
                            : "\$$minPrice - $maxPrice",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .apply(decoration: TextDecoration.lineThrough),
                      ),
                      const SizedBox(
                        width: TSizes.spaceBtwItems,
                      ),
                      TProductPriceText(
                        price: minPrice == maxPrice
                            ? priceAfterDis(minPrice, discount)
                            : " ${priceAfterDis(minPrice, discount)} - ${priceAfterDis(maxPrice, discount)}",
                        isLarge: true,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwItems / 1.5,
                  ),

                  /// Title
                  TProductTitleText(title: product.name),
                  const SizedBox(
                    height: TSizes.spaceBtwItems / 1.5,
                  ),

                  /// Stock Status
                  Row(
                    children: [
                      const TProductTitleText(title: 'Status: '),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      Text(
                        product.variants_path.isNotEmpty
                            ? 'In stock'
                            : 'Out of stock',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwItems / 1.5,
                  ),

                  /// Brand
                  Row(
                    children: [
                      TCircularImage(
                        image: TImages.shoeIcon,
                        width: 32,
                        height: 32,
                        overlayColor: darkMode ? TColors.white : TColors.black,
                      ),
                      TBrandTitleWithVerifiedIcon(
                        isVerified: isVerified,
                        title: nameBrand,
                        brandTextSize: TextSizes.medium,
                      ),
                    ],
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Center(child: Text("smt went wrong"));
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
