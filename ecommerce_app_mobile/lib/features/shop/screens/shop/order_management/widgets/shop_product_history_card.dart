import 'package:ecommerce_app_mobile/common/styles/product_price_text.dart';
import 'package:ecommerce_app_mobile/common/styles/t_brand_title_text_with_verified_icon.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/loading/custom_loading.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/shop_controller/shop_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/shop_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/shop/order_management/shop_product_order_details.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/shop/order_management/widgets/shop_product_history_item.dart';

import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/enums.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopProductOrderCard extends StatelessWidget {
  ShopProductOrderCard({
    super.key,
    required this.shopAndProducts,
  });

  final shopController = Get.put(ShopController());

  final Map shopAndProducts;

  Color getColorFromHex(String hexColor) {
    try {
      hexColor = hexColor.replaceAll("#", "");

      if (hexColor.length == 6 || hexColor.length == 8) {
        return Color(int.parse("0xFF$hexColor"));
      } else {
        return Colors.grey;
      }
    } catch (e) {
      print("Error converting HEX to Color: $e");
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: shopController.getShopAndProductsOrderInfo(shopAndProducts),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final data = snapshot.data!;

            final firstProduct = (data['products'] as List).first as Map;

            final firstProductModel = firstProduct['product'] as ProductModel;
            final firstBrandModel = firstProduct['brand'] as BrandModel;
            final firstProductVariantModel =
                firstProduct['productVariant'] as ProductVariantModel;
            final firstProductQuantity = firstProduct['quantity'];

            return InkWell(
              borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
              onTap: () {
                Get.to(
                  () => ShopProductOrderDetails(
                    shopAndProducts: shopAndProducts,
                  ),
                );
              },
              child: TRoundedContainer(
                width: double.infinity,
                showBorder: true,
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: Colors.transparent,
                borderColor: THelperFunctions.isDarkMode(context)
                    ? TColors.darkGrey
                    : TColors.grey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TBrandTitleWithVerifiedIcon(
                            title: (data['shopModel'] as ShopModel).name,
                            isVerified: false,
                            brandTextSize: TextSizes.large,
                          ),
                          const Spacer(),
                          Text(
                            shopAndProducts['status'],
                            style: Theme.of(context).textTheme.bodyLarge!.apply(
                                  color: shopAndProducts['status'] ==
                                          'confirmation'
                                      ? TColors.primary.withOpacity(
                                          0.7,
                                        )
                                      : shopAndProducts['status'] ==
                                              'delivering'
                                          ? TColors.primary.withOpacity(
                                              0.7,
                                            )
                                          : shopAndProducts['status'] ==
                                                  'completed'
                                              ? TColors.success.withOpacity(
                                                  0.7,
                                                )
                                              : TColors.error.withOpacity(
                                                  0.7,
                                                ),
                                  fontWeightDelta: 1,
                                ),
                          ),
                        ],
                      ),
                    ),
                    ShopProductOrderItem(
                      brand: firstBrandModel.name,
                      color: getColorFromHex(firstProductVariantModel.color),
                      imgUrl: firstProductVariantModel.imageURL,
                      size: firstProductVariantModel.size,
                      title: firstProductModel.name,
                      discount: firstProductModel.discount,
                      price: firstProductVariantModel.price,
                      quantity: firstProductQuantity,
                    ),
                    const SizedBox(height: TSizes.sm),
                    const Divider(
                      height: 10,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: TColors.divider,
                    ),
                    Text(
                      'See more products',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const Divider(
                      height: 10,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: TColors.divider,
                    ),
                    Row(
                      children: [
                        Text(
                            '${(shopAndProducts['package'] as Map).keys.length} products',
                            style: Theme.of(context).textTheme.bodyMedium),
                        const Spacer(),
                        Text(
                          'Total: ',
                          style: Theme.of(context).textTheme.titleMedium!,
                        ),
                        TProductPriceText(
                          price: shopAndProducts['total'],
                          color: TColors.primary.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Center(child: Text("smt went wrong"));
          }
        } else {
          return const Center(
            child: CustomLoading(),
          );
        }
      },
    );
  }
}
