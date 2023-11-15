import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        title: Text('All Products'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              DropdownButtonFormField(
                decoration:
                    const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
                items: [
                  'Name',
                  'Higher Price',
                  'Lower Price',
                  'Sale',
                  'Newest',
                  'Populariry'
                ]
                    .map(
                      (option) => DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      ),
                    )
                    .toList(),
                onChanged: (value) {},
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              TGridLayout(
                itemCount: 8,
                itemBuilder: (p0, index) {
                  return const TProductCardVertical();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
