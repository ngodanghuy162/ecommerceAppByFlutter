import 'package:ecommerce_app_mobile/features/shop/controllers/brands_controller/brands_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/brands/brand_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/sizes.dart';
import '../../layout/grid_layout.dart';
import '../product_cards/product_card_vertical.dart';

class TSortableProducts extends StatelessWidget {
  TSortableProducts({
    super.key,
    required this.brand,
  });
  final BrandModel brand;

  final productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Drop down
        DropdownButtonFormField(
          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
          onChanged: (value) {},
          items: [
            'Name',
            'Higher Price',
            'Lower Price',
            'Sale',
            'Newest',
            'Popularity'
          ]
              .map((option) =>
                  DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
        ),
        const SizedBox(
          height: TSizes.spaceBtwItems,
        ),

        /// Product
        FutureBuilder(
            future: productController.getAllProductbyBrand("Brand/${brand.id}"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return TGridLayout(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => TProductCardVertical(
                            product: snapshot.data![index],
                            brand: brand,
                          ));
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: Text("smt went wrong"));
                }
              } else {
                return const CircularProgressIndicator();
              }
            })
      ],
    );
  }
}
