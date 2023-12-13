import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/brand_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_variant_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/sizes.dart';
import '../../layout/grid_layout.dart';
import '../product_cards/product_card_vertical.dart';

class TSortableProducts extends StatefulWidget {
  TSortableProducts({
    super.key,
    required this.type,
  });

  final String type;

  @override
  State<TSortableProducts> createState() => _TSortableProductsState();
}

class _TSortableProductsState extends State<TSortableProducts> {
  final productController = Get.put(ProductController());
  final brandController = Get.put(BrandController());
  final variantController = Get.put(ProductVariantController());
  String status = '';

  @override
  Widget build(BuildContext context) {
    String type = widget.type;
    return Column(
      children: [
        /// Drop down
        DropdownButtonFormField(
          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
          onChanged: (value) {
            setState(() {
              status = value!;
            });
          },
          items: ['Name', 'Higher Price', 'Lower Price', 'Sale']
              .map((option) =>
                  DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
        ),
        const SizedBox(
          height: TSizes.spaceBtwItems,
        ),
        const SizedBox(
          height: TSizes.spaceBtwItems,
        ),

        /// Product
        FutureBuilder(
            future: productController.getAllProductbyBrand(
                "${brandController.choosedBrand.value.id}"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<ProductModel> listProducts = snapshot.data!;
                  if (status == 'Name') {
                    listProducts.sort(((a, b) => a.name.compareTo(b.name)));
                  } else if (status == 'Higher Price') {
                  } else if (status == 'Lower Price') {
                  } else if (status == 'Sale') {
                    listProducts
                        .sort(((a, b) => b.discount!.compareTo(a.discount!)));
                  }

                  return TGridLayout(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => TProductCardVertical(
                            product: listProducts[index],
                            brand: brandController.choosedBrand.value,
                          ));
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: Text("smt went wrong"));
                }
              } else {
                return const CircularProgressIndicator();
              }
            }),
        FutureBuilder(
            future: productController.getAllProductbyBrand(
                "Brand/${brandController.choosedBrand.value.id}"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return TGridLayout(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => TProductCardVertical(
                            product: snapshot.data![index],
                            brand: brandController.choosedBrand.value,
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
