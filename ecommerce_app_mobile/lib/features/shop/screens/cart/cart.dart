import 'package:ecommerce_app_mobile/common/styles/product_price_text.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/cart/add_remove_button.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/cart/t_cart_item.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/cart/cart_items_widget/cart_items.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/checkout/checkout_screen.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Cart',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: TCartItems(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(
            onPressed: () => Get.to(() => const CheckoutScreen()),
            child: const Text('Checkout \$256')),
      ),
    );
  }
}
