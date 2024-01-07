import 'package:ecommerce_app_mobile/common/styles/t_brand_title_text_with_verified_icon.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/loading/custom_loading.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/shop_controller/shop_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/shop_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/checkout/widgets/billing_amout_section.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_history_order/widgets/product_history_item.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/shop/order_management/widgets/dropdown_menu_shop_order_status.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/enums.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';

class ShopProductOrderDetails extends StatefulWidget {
  ShopProductOrderDetails({
    super.key,
    required this.shopAndProducts,
  });

  final Map shopAndProducts;

  @override
  State<ShopProductOrderDetails> createState() =>
      _ShopProductOrderDetailsState();
}

class _ShopProductOrderDetailsState extends State<ShopProductOrderDetails> {
  final shopController = Get.put(ShopController());

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
          future: shopController
              .getShopAndProductsOrderInfo(widget.shopAndProducts),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                final products = (data['products'] as List);

                final userAddress = widget.shopAndProducts['user_address'];
                // final shopAddress = shopAndProducts['shop_address'];

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
                                  widget.shopAndProducts['status'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .apply(
                                        color:
                                            widget.shopAndProducts['status'] ==
                                                    'confirmation'
                                                ? TColors.primary.withOpacity(
                                                    0.7,
                                                  )
                                                : widget.shopAndProducts[
                                                            'status'] ==
                                                        'delivering'
                                                    ? TColors.primary
                                                        .withOpacity(
                                                        0.7,
                                                      )
                                                    : widget.shopAndProducts[
                                                                'status'] ==
                                                            'completed'
                                                        ? TColors.success
                                                            .withOpacity(
                                                            0.7,
                                                          )
                                                        : TColors.error
                                                            .withOpacity(
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
                            shippingFee: widget.shopAndProducts['shipping'],
                            subTotal: widget.shopAndProducts['sub_total'],
                            total: widget.shopAndProducts['total'],
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
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: DropdownMenuShopOrderStatus(
            initialValue: widget.shopAndProducts['status'],
            onChanged: (String value) async {
              await shopController.setOrderStatus(
                  widget.shopAndProducts['order_id'], value);
            },
          )),
    );
  }
}
