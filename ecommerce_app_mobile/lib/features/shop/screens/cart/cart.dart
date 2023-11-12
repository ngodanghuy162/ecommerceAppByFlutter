import 'package:ecommerce_app_mobile/common/styles/product_price_text.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/products_cart/add_remove_button.dart';
import '../../../../common/widgets/products_cart/t_cart_item.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: ListView.separated(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return const SizedBox(height: TSizes.spaceBtwSections);
            },
            itemCount: 10,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  const TCartItem(),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 70),
                      TProductQuantityWithAddAndRemove(),
                      TProductPriceText(price: '256'),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(
            onPressed: () {}, child: const Text('Checkout \$256')),
      ),
    );
  }
}
