import 'package:ecommerce_app_mobile/Service/repository/address_repository.dart';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/common/styles/t_brand_title_text_with_verified_icon.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/checkout/checkout_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/shop_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/checkout/widgets/billing_shipment_section.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_history_order/widgets/product_history_item.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/enums.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopAndProducts extends StatelessWidget {
  ShopAndProducts({
    super.key,
    required this.shop,
    this.currentShipmentService,
  });

  final controller = Get.put(CheckoutController());
  final addressRepository = Get.put(AddressRepository());
  final userRepository = Get.put(UserRepository());

  final Map? currentShipmentService;

  final Map<String, Map<String, int>> shop;

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
    controller.getShopAndProductsCheckoutInfo(shop);
    return FutureBuilder(
        future: controller.getShopAndProductsCheckoutInfo(shop),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final shopModel = snapshot.data!['shopModel'] as ShopModel;
              final List products = snapshot.data!['products'];

              final defaultShopAddress = shopModel.address!
                  .singleWhere((element) => element['isDefault']);

              return TRoundedContainer(
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //Shop name
                          TBrandTitleWithVerifiedIcon(
                            title: shopModel.name,
                            brandTextSize: TextSizes.large,
                          ),
                          const Spacer()
                        ],
                      ),
                    ),
                    ...products.map(
                      (e) {
                        final brandModel = e['brand'] as BrandModel;
                        final productModel = e['product'] as ProductModel;
                        final productVariantModel =
                            e['productVariant'] as ProductVariantModel;

                        final quantity = e['quantity'] as int;
                        controller.productListPaypal.add({
                          'name': productModel.name,
                          'quantity': quantity,
                          'price': (productVariantModel.price -
                                  productVariantModel.price *
                                      productModel.discount! /
                                      100)
                              .toStringAsFixed(2),
                          'currency': 'USD'
                        });

                        return ProductOrderItem(
                          brand: brandModel.name,
                          color: getColorFromHex(productVariantModel.color),
                          imgUrl: productVariantModel.imageURL,
                          size: productVariantModel.size,
                          title: productModel.name,
                          quantity: quantity,
                          discount: productModel.discount,
                          price: productVariantModel.price,
                        );
                      },
                    ).toList(),
                    const SizedBox(height: TSizes.sm),
                    const Divider(
                      height: 10,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: TColors.divider,
                    ),
                    FutureBuilder(
                      future: addressRepository.getShippingServiceAvailable(
                        '4683322',
                        defaultShopAddress['districtId'],
                        userRepository.getDefaultAddress()['districtId'],
                      ),
                      builder: (context, snapshot_) {
                        if (snapshot_.connectionState == ConnectionState.done) {
                          if (snapshot_.hasData) {
                            return TBillingShipmentSection(
                              shipmentServiceAvailable: snapshot_.data!,
                              subTotal: snapshot.data!['subTotal'],
                              defaultShopAddress: defaultShopAddress,
                              shopEmail: shopModel.owner,
                              items: products.map(
                                (e) {
                                  // final brandModel = e['brand'] as BrandModel;
                                  final productModel =
                                      e['product'] as ProductModel;
                                  // final productVariantModel =
                                  //     e['productVariant']
                                  //         as ProductVariantModel;

                                  final quantity = e['quantity'] as int;
                                  return {
                                    'name': productModel.name,
                                    'quantity': quantity,
                                    'height': 20,
                                    "weight": 750,
                                    "length": 20,
                                    "width": 20
                                  };
                                },
                              ).toList(),
                            );
                          } else if (snapshot_.hasError) {
                            return Center(
                                child: Text(snapshot_.error.toString()));
                          } else {
                            return const Center(child: Text("smt went wrong"));
                          }
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
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
