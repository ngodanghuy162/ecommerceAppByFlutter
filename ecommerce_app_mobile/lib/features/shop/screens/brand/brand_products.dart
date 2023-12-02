import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/brands/brand_card.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/sortable/sortable_product.dart';
import 'package:ecommerce_app_mobile/features/shop/models/brands/brand_model.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class BrandProducts extends StatelessWidget {
  const BrandProducts({super.key, required this.brand});
  final BrandModel? brand;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text(brand!.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            /// Brand Detail
            TBrandCard(
                showBorder: true,
                nameBrand: brand!.name,
                showVerify: brand!.is_verified),
            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),
            TSortableProducts(brand: brand),
          ],
        ),
      ),
    );
  }
}
