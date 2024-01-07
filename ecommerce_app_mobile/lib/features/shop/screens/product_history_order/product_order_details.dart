import 'package:ecommerce_app_mobile/Service/repository/order_respository/order_respository.dart';
import 'package:ecommerce_app_mobile/common/styles/t_brand_title_text_with_verified_icon.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/loading/custom_loading.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/shop_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/checkout/widgets/billing_amout_section.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_history_order/widgets/product_history_item.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_repository.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/enums.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductOrderDetails extends StatelessWidget {
  ProductOrderDetails({
    super.key,
    required this.shopAndProducts,
    this.showReviewModal,
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
    return Scaffold(
      appBar: TAppBar(
          showBackArrow: true,
          title: Text("Order details",
              style: Theme.of(context).textTheme.headlineSmall)),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: FutureBuilder(
          future: orderRepository.getShopAndProductsOrderInfo(shopAndProducts),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                final products = (data['products'] as List);

                final userAddress = shopAndProducts['user_address'];
                final shopAddress = shopAndProducts['shop_address'];

                return ListView(
                  children: [
                    TRoundedContainer(
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .apply(
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
                                                    ? TColors.success
                                                        .withOpacity(
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
                          Column(
                            children: [
                              ...products.map(
                                (data) {
                                  final productModel =
                                      data['product'] as ProductModel;
                                  final brandModel =
                                      data['brand'] as BrandModel;
                                  final productVariantModel =
                                      data['productVariant']
                                          as ProductVariantModel;
                                  final productQuantity = data['quantity'];
                                  return ProductOrderItem(
                                    brand: brandModel.name,
                                    color: getColorFromHex(
                                        productVariantModel.color),
                                    imgUrl: productVariantModel.imageURL,
                                    size: productVariantModel.size,
                                    title: productModel.name,
                                    discount: productModel.discount,
                                    price: productVariantModel.price,
                                    quantity: productQuantity,
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: TSizes.sm),
                          const Divider(
                            height: 10,
                            thickness: 1,
                            indent: 0,
                            endIndent: 0,
                            color: TColors.divider,
                          ),
                          TBillingAmountSection(
                            shippingFee: shopAndProducts['shipping'],
                            subTotal: shopAndProducts['sub_total'],
                            total: shopAndProducts['total'],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: TSizes.defaultSpace),
                    TRoundedContainer(
                      width: double.infinity,
                      showBorder: true,
                      padding: const EdgeInsets.all(TSizes.md),
                      backgroundColor: Colors.transparent,
                      borderColor: THelperFunctions.isDarkMode(context)
                          ? TColors.darkGrey
                          : TColors.grey,
                      child: Column(
                        children: [
                          const TBillingPaymentSection(showChangeButton: false),
                          const Divider(
                            height: 10,
                            thickness: 1,
                            indent: 0,
                            endIndent: 0,
                            color: TColors.divider,
                          ),
                          TBillingAddressSection(
                            name: userAddress['name'],
                            phoneNumber: userAddress['phoneNumber'],
                            fullAddress:
                                '${userAddress['province']}, ${userAddress['district']}, ${userAddress['ward']}, ${userAddress['street']}',
                            showChangeButton: false,
                          )
                        ],
                      ),
                    ),
                  ],
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
        ),
      ),
      bottomNavigationBar: shopAndProducts['status'] == 'completed'
          ? Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: ElevatedButton(
                onPressed: () async {
                  final productVariantList =
                      (shopAndProducts['package'] as Map).keys.toList();
                  final List<ProductModel?> productModelList = [];
                  for (var element in productVariantList) {
                    productModelList.add(
                        await productRepository.getProductByVariantId(element));
                  }

                  final List<Map<String, String>> dropdownProductMap =
                      productModelList
                          .map((e) => {'key': e!.id!, 'value': e.name})
                          .toList();

                  // ignore: use_build_context_synchronously
                  showReviewModal!(context, dropdownProductMap);
                },
                child: const Text("Review"),
              ),
            )
          : const SizedBox(
              height: 0,
              width: 0,
            ),
    );
  }
}
