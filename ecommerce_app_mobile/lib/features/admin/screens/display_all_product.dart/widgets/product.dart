import 'package:ecommerce_app_mobile/features/admin/screens/display_all_product.dart/widgets/product_base.dart';
import 'package:ecommerce_app_mobile/features/admin/screens/display_all_product.dart/widgets/product_variant.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProductWithVariant extends StatelessWidget {
  const ProductWithVariant({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.separated(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return const SizedBox(height: TSizes.spaceBtwSections);
        },
        itemCount: 5,
        itemBuilder: (context, index) {
          return const Column(
            children: [
              SizedBox(height: TSizes.spaceBtwItems),
              ExpansionTile(
                title: ProductBase(),
                children: [
                  ProductVariant(
                    color: 'red',
                    size: 'XS',
                    price: '10',
                    inStock: '30',
                  ),
                  ProductVariant(
                    color: 'blue',
                    size: 'L',
                    price: '10',
                    inStock: '20',
                  ),
                  ProductVariant(
                    color: 'white',
                    size: 'XL',
                    price: '10',
                    inStock: '25',
                  ),
                  ProductVariant(
                    color: 'black',
                    size: 'S',
                    price: '10',
                    inStock: '20',
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
