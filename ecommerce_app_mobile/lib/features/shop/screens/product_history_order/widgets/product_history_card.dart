import 'package:ecommerce_app_mobile/Service/repository/order_respository/order_respository.dart';
import 'package:ecommerce_app_mobile/common/styles/product_price_text.dart';
import 'package:ecommerce_app_mobile/common/styles/t_brand_title_text_with_verified_icon.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/loading/custom_loading.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/shop_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_history_order/product_order_details.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_history_order/widgets/product_history_item.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_repository.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/enums.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductOrderCard extends StatelessWidget {
  ProductOrderCard({
    super.key,
    this.showReviewModal,
    required this.shopAndProducts,
  });

  final void Function(BuildContext context, List<Map<String, String>> products)?
      showReviewModal;
  final orderRepository = Get.put(OrderRepository());
  final productRepository = Get.put(ProductRepository());

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
      future: orderRepository.getShopAndProductsOrderInfo(shopAndProducts),
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
                Get.to(() => ProductOrderDetails(
                      shopAndProducts: shopAndProducts,
                      showReviewModal: showReviewModal,
                    ));
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
                    ProductOrderItem(
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
                    if (shopAndProducts['status'] == 'completed')
                      const Divider(
                        height: 10,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                        color: TColors.divider,
                      ),
                    if (shopAndProducts['status'] == 'completed')
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () async {
                                final productVariantList =
                                    (shopAndProducts['package'] as Map)
                                        .keys
                                        .toList();
                                final List<ProductModel?> productModelList = [];
                                for (var element in productVariantList) {
                                  productModelList.add(await productRepository
                                      .getProductByVariantId(element));
                                }

                                final List<Map<String, String>>
                                    dropdownProductMap = productModelList
                                        .map((e) =>
                                            {'key': e!.id!, 'value': e.name})
                                        .toList();

                                // ignore: use_build_context_synchronously
                                showReviewModal!(context, dropdownProductMap);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 24.0,
                                ), // Đặt khoảng cách giữa chữ và viền
                              ),
                              child: const Text(
                                'Review',
                              ),
                            )
                          ],
                        ),
                      )
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
