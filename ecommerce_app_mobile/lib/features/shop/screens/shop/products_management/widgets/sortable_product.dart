import 'dart:math';

import 'package:ecommerce_app_mobile/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/brand_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_variant_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/products_management/products_management_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/detail_product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_category_repository.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ShopSortableProducts extends StatefulWidget {
  const ShopSortableProducts({
    super.key,
  });

  @override
  State<ShopSortableProducts> createState() => _ShopSortableProductsState();
}

class _ShopSortableProductsState extends State<ShopSortableProducts> {
  final productController = Get.put(ProductController());
  final brandController = Get.put(BrandController());
  final variantController = Get.put(ProductVariantController());
  final productCategoryRepository = Get.put(ProductCategoryRepository());

  final productsManagementController = Get.put(ProductsManagementController());
  Widget showWidget = const Center(
    child: Text('No products yet.'),
  );

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ListView(
          children: [
            /// Drop down

            DropdownButtonFormField(
              decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
              value: productsManagementController.currentCategory.value,
              onChanged: (value) {
                setState(() {
                  productsManagementController.currentCategory.value = value!;
                });
              },
              items: productsManagementController.categoryList
                  .map((option) => DropdownMenuItem(
                      value: option['id'] as String,
                      child: Text(option['name']!)))
                  .toList(),
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),

            /// Drop down
            DropdownButtonFormField(
              decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
              value: productsManagementController.status.value,
              onChanged: (value) {
                setState(() {
                  productsManagementController.status.value = value!;
                  productsManagementController.sortProductList();
                });
              },
              items: ['Name', 'Higher Price', 'Lower Price', 'Sale']
                  .map((option) =>
                      DropdownMenuItem(value: option, child: Text(option)))
                  .toList(),
            ),
            const SizedBox(
              height: TSizes.defaultSpace,
            ),

            TGridLayout(
              itemCount: productsManagementController.getProductList().length,
              itemBuilder: (_, index) => FutureBuilder(
                future: variantController.getVariantByIDs(
                    //* GET ALL VARIANTS BY PRODUCT IDS
                    productsManagementController
                        .getProductList()[index]
                        .variants_path),
                builder: (context, snapshot2) {
                  if (snapshot2.connectionState == ConnectionState.done) {
                    if (snapshot2.hasData) {
                      List<ProductVariantModel> listVariants = snapshot2.data!;
                      return TProductCardVertical(
                        modelDetail: DetailProductModel(
                          brand: brandController.choosedBrand.value,
                          listVariants: listVariants,
                          product: productsManagementController
                              .getProductList()[index],
                        ),
                      );
                    } else if (snapshot2.hasError) {
                      return Center(child: Text(snapshot2.error.toString()));
                    } else {
                      return const Center(child: Text("smt went wrong"));
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
