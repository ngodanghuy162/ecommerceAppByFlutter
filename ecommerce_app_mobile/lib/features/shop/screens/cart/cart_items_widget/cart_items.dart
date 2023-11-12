import 'package:ecommerce_app_mobile/common/styles/product_price_text.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/cart/add_remove_button.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/cart/t_cart_item.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TCartItems extends StatelessWidget {
  const TCartItems({super.key, this.showAddRemoveButton = true});

    final bool showAddRemoveButton;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                if (showAddRemoveButton)
                const SizedBox(height: TSizes.spaceBtwItems),
                if (showAddRemoveButton)
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
    );
  }
}
