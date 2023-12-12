import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/brands/brand_card.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/sortable/sortable_product.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/brand_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrandProducts extends StatelessWidget {
  BrandProducts({super.key, required this.brand});
  final BrandModel brand;
  final brandController = Get.put(BrandController());
  @override
  Widget build(BuildContext context) {
    brandController.choosedBrand.value = brand;
    return Scaffold(
        appBar: TAppBar(
          title: Text(brand.name),
          showBackArrow: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// Brand Detail
              TBrandCard(showBorder: true, brand: brand),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              TSortableProducts(type: "Brand"),
            ],
          ),
        ));
  }
}
