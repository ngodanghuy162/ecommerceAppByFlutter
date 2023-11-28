import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/features/admin/screens/display_all_product.dart/widgets/product.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProductWareHouseScreen extends StatelessWidget {
  const ProductWareHouseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        title: Text('My Products'),
        showBackArrow: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              DropdownButtonFormField(
                decoration:
                    const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
                items: ['Cate1', 'Cate2']
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
              const Column(children: [
                ProductWithVariant(),
                ProductWithVariant(),
                ProductWithVariant(),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
