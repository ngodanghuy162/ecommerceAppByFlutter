import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/cart/coupon_widget.dart';
import 'package:ecommerce_app_mobile/common/widgets/success_screen/success_screen.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/cart/cart_items_widget/cart_items.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:ecommerce_app_mobile/navigation_menu.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/api_constants.dart'
    as api_constant;
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
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
              const TCartItems(showAddRemoveButton: false),
              const SizedBox(height: TSizes.spaceBtwSections),
              const TCouponCode(),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              TRoundedContainer(
                showBorder: true,
                backgroundColor: dark ? TColors.black : TColors.white,
                child: const Padding(
                  padding: EdgeInsets.only(
                    top: TSizes.sm,
                    bottom: TSizes.sm,
                    right: TSizes.sm,
                    left: TSizes.md,
                  ),
                  child: Column(
                    children: [
                      TBillingPaymentSection(),
                      SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                      Divider(),
                      SizedBox(
                        height: TSizes.spaceBtwSections,
                      ),
                      TBillingAddressSection(),
                      SizedBox(
                        height: TSizes.spaceBtwItems,
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
          onPressed: () => Get.to(
            // SuccessScreen(
            //     title: "Payment success",
            //     subtitle: "Your items will be shipped soon",
            //     callback: () => Get.offAll(() => const NavigationMenu()),
            //     image: TImages.successfulPaymentIcon),
            UsePaypal(
              sandboxMode: true,
              clientId: api_constant.clientId,
              secretKey: api_constant.secretKey,
              returnURL: api_constant.returnURL,
              cancelURL: api_constant.cancelURL,
              transactions: const [
                {
                  "amount": {
                    "total": '10.12',
                    "currency": "USD",
                    "details": {
                      "subtotal": '10.12',
                      "shipping": '0',
                      "shipping_discount": 0
                    }
                  },
                  "description": "The payment transaction description.",
                  // "payment_options": {
                  //   "allowed_payment_method":
                  //       "INSTANT_FUNDING_SOURCE"
                  // },
                  "item_list": {
                    "items": [
                      {
                        "name": "A demo product",
                        "quantity": 1,
                        "price": '10.12',
                        "currency": "USD"
                      }
                    ],

                    // shipping address is not required though
                    "shipping_address": {
                      "recipient_name": "Jane Foster",
                      "line1": "Travis County",
                      "line2": "",
                      "city": "Austin",
                      "country_code": "US",
                      "postal_code": "73301",
                      "phone": "+00000000",
                      "state": "Texas"
                    },
                  }
                }
              ],
              note: "Contact us for any questions on your order.",
              onSuccess: (Map params) {
                print("onSuccess: $params");

                Get.to(
                  () => SuccessScreen(
                      title: "Payment success",
                      subtitle: "Your items will be shipped soon",
                      callback: () => Get.offAll(() => const NavigationMenu()),
                      image: TImages.successfulPaymentIcon),
                );

                // Get.snackbar(
                //   'Payment success',
                //   'Your items will be shipped soon',
                //   colorText: Colors.green,
                //   backgroundColor: Colors.greenAccent.withOpacity(0.1),
                //   snackPosition: SnackPosition.TOP,
                // );
                // Get.showSnackbar(
                //   GetSnackBar(
                //     titleText: const Text(
                //       'Payment success',
                //       style: TextStyle(
                //         color: Colors.green,
                //       ),
                //     ),
                //     messageText: const Text(
                //       'Your items will be shipped soon',
                //       style: TextStyle(
                //         color: Colors.green,
                //       ),
                //     ),
                //     snackPosition: SnackPosition.BOTTOM,
                //     duration: const Duration(seconds: 2),
                //     backgroundColor: Colors.greenAccent.withOpacity(0.5),
                //     borderRadius: 20,
                //   ),
                // );
                // Navigator.of(context).pop();
              },
              onError: (error) {
                print("onError: $error");
              },
              onCancel: (params) {
                print('cancelled: $params');
              },
            ),
          ),
          child: const Text("Checkout \$256"),
        ),
      ),
    );
  }
}
