import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/order_model/order_model.dart';
import 'package:ecommerce_app_mobile/Service/Model/order_model/payment_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/address_repository.dart';
import 'package:ecommerce_app_mobile/Service/repository/order_respository/order_respository.dart';
import 'package:ecommerce_app_mobile/Service/repository/order_respository/payment_repository.dart';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/cart/coupon_widget.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/checkout/checkout_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/shop_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/checkout/widgets/shop_and_products.dart';
import 'package:ecommerce_app_mobile/common/widgets/success_screen/success_screen.dart';
import 'package:ecommerce_app_mobile/features/personalization/controllers/address_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/checkout/widgets/billing_amout_section.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:ecommerce_app_mobile/navigation_menu.dart';
import 'package:ecommerce_app_mobile/repository/shop_repository/shop_repository.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/api_constants.dart'
    as api_constant;
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';

class CheckoutScreen extends StatefulWidget {
  CheckoutScreen({
    super.key,
    required this.shopAndProductVariantQuantity,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();

  final Map<String, Map<String, int>> shopAndProductVariantQuantity;
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final addressController = Get.put(AddressController());

  var isSuccess = false;

  final paymentController = Get.put(PaymentRepository());

  final userController = Get.put(UserRepository());

  final orderController = Get.put(OrderRepository());

  final addressRepository = Get.put(AddressRepository());
  final shopRepository = Get.put(ShopRepository());

  final controller = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    final currentUserModel = userController.currentUserModel;
    Map<String, dynamic> currentUserAddress = currentUserModel!.address!
        .singleWhere((element) => element['isDefault']);

    return Scaffold(
      appBar: TAppBar(
          showBackArrow: true,
          title: Text("Order Review",
              style: Theme.of(context).textTheme.headlineSmall)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              ...widget.shopAndProductVariantQuantity.keys
                  .map((e) => Container(
                        margin: const EdgeInsets.only(
                          bottom: TSizes.md,
                        ),
                        child: Column(
                          children: [
                            ShopAndProducts(
                              shop: {
                                e: widget.shopAndProductVariantQuantity[e]!,
                              },
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems),
                            const TCouponCode(),
                          ],
                        ),
                      ))
                  .toList(),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              TRoundedContainer(
                showBorder: true,
                backgroundColor: dark ? TColors.black : TColors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: TSizes.sm,
                    bottom: TSizes.sm,
                    right: TSizes.sm,
                    left: TSizes.md,
                  ),
                  child: Column(
                    children: [
                      Obx(
                        () => TBillingAmountSection(
                          subTotal: controller.costList
                              .fold(
                                0.0,
                                (previousValue, element) =>
                                    previousValue +
                                    double.parse(element['cost']['subTotal']),
                              )
                              .toStringAsFixed(2),
                          total: controller.costList
                              .fold(
                                0.0,
                                (previousValue, element) =>
                                    previousValue +
                                    double.parse(element['cost']['total']),
                              )
                              .toStringAsFixed(2),
                          shippingFee: controller.costList
                              .fold(
                                0.0,
                                (previousValue, element) =>
                                    previousValue +
                                    double.parse(
                                        element['cost']['shippingFee']),
                              )
                              .toStringAsFixed(2),
                        ),
                      ),
                      const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                      const Divider(),
                      const TBillingPaymentSection(),
                      const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                      const Divider(),
                      TBillingAddressSection(
                        name: currentUserAddress['name'],
                        phoneNumber: currentUserAddress['phoneNumber'],
                        fullAddress:
                            '${currentUserAddress['province']}, ${currentUserAddress['district']}, ${currentUserAddress['ward']}, ${currentUserAddress['street']}',
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () async {
            Get.to(() => UsePaypal(
                  sandboxMode: true,
                  clientId: api_constant.clientId,
                  secretKey: api_constant.secretKey,
                  returnURL: api_constant.returnURL,
                  cancelURL: api_constant.cancelURL,
                  transactions: [
                    {
                      "amount": {
                        "total": controller.costList
                            .fold(
                              0.0,
                              (previousValue, element) =>
                                  previousValue +
                                  double.parse(element['cost']['total']),
                            )
                            .toStringAsFixed(2),
                        "currency": "USD",
                        "details": {
                          "subtotal": controller.costList
                              .fold(
                                0.0,
                                (previousValue, element) =>
                                    previousValue +
                                    double.parse(element['cost']['subTotal']),
                              )
                              .toStringAsFixed(2),
                          "shipping": controller.costList
                              .fold(
                                0.0,
                                (previousValue, element) =>
                                    previousValue +
                                    double.parse(
                                        element['cost']['shippingFee']),
                              )
                              .toStringAsFixed(2),
                          "shipping_discount": 0
                        }
                      },
                      "description": "The payment transaction description.",
                      // "payment_options": {
                      //   "allowed_payment_method":
                      //       "INSTANT_FUNDING_SOURCE"
                      // },
                      "item_list": {
                        "items": [...controller.productListPaypal],

                        // shipping address is not required though
                        "shipping_address": {
                          "recipient_name": currentUserAddress['name'],
                          "line1": currentUserAddress['street'],
                          "line2": "",
                          "city": currentUserAddress['province'],
                          "country_code": "VN",
                          "postal_code": currentUserAddress['wardCode'],
                          "phone": currentUserAddress['phoneNumber'],
                          "state": currentUserAddress['district']
                        },
                      }
                    }
                  ],
                  note: "Contact us for any questions on your order.",
                  onSuccess: (Map params) async {
                    print("onSuccess: $params");

                    if (!isSuccess) {
                      print('starrt');
                      //process
                      final userId = userController.currentUserModel!.id!;
                      for (var shopEmail
                          in widget.shopAndProductVariantQuantity.keys) {
                        final cost = controller.costList.singleWhere(
                            (element) =>
                                element['shopEmail'] == shopEmail)['cost'];
                        final String paymentId =
                            await paymentController.addPaymentSuccess(
                          PaymentModel(
                            paymentDate: Timestamp.now(),
                            userId: userId,
                            shopEmail: shopEmail,
                            paymentMethod: 'paypal',
                            shipping: cost['shippingFee'],
                            discount: '0',
                            total: cost['total'],
                            subTotal: cost['subTotal'],
                          ),
                        );
                        ShopModel shopData =
                            await shopRepository.getShopByEmail(shopEmail);

                        orderController.addOrderSuccess(
                          OrderModel(
                            shopEmail: shopEmail,
                            package: widget.shopAndProductVariantQuantity[widget
                                .shopAndProductVariantQuantity
                                .keys
                                .first] as Map<String, dynamic>,
                            paymentId: paymentId,
                            status: 'confirmation',
                            userId: userId,
                            shopAddress: shopData.address!.singleWhere(
                              (element) => element['isDefault'],
                            ),
                            userAddress: currentUserAddress,
                          ),
                        );
                      }
                      print('end');

                      isSuccess = true;
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        Get.offAll(
                          () => SuccessScreen(
                              title: "Payment success",
                              subtitle: "Your items will be shipped soon",
                              callback: () async {
                                SmartDialog.dismiss();
                                isSuccess = false;

                                Get.offAll(const NavigationMenu());
                                // Get.back();
                              },
                              image: TImages.successfulPaymentIcon),
                        );
                      });
                    }
                  },
                  onError: (error) {
                    print("onError: $error");
                  },
                  onCancel: (params) {
                    print('cancelled: $params');
                  },
                ));
          },
          child: Obx(() {
            final total = controller.costList.fold(
              0.0,
              (previousValue, element) =>
                  previousValue + double.parse(element['cost']['total']),
            );
            return Text("Checkout \$${total.toStringAsFixed(2)}");
          }),
        ),
      ),
    );
  }
}
