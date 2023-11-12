import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/cart/coupon_widget.dart';
import 'package:ecommerce_app_mobile/common/widgets/success_screen/success_screen.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/cart/cart_items_widget/cart_items.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:ecommerce_app_mobile/navigation_menu.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
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
                TCouponCode(),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                TRoundedContainer(
                  showBorder: true,
                  backgroundColor: dark ? TColors.black : TColors.white,
                  child: Column(
                    children: [
                      TBillingPaymentSection(),
                      const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: TSizes.spaceBtwSections,
                      ),
                      TBillingAddressSection(),
                      const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: ElevatedButton(
              onPressed: () => Get.to(() => SuccessScreen(
                  title: "Payment success",
                  subtitle: "Your items will be shipped soon",
                  callback: () => Get.offAll(() => const NavigationMenu()),
                  image: TImages.successfulPaymentIcon)),
              child: const Text("Checkout \$256"),
            )));
  }
}