import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/brand_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_variant_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/detail_product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
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
  Widget showWidget = const Center(
    child: Text('No products yet.'),
  );
  String status = '';

  @override
  Widget build(BuildContext context) {
    String type = widget.type;

    if (type == 'brand') {
      showWidget = FutureBuilder(
          future: productController
              .getAllProductbyBrand(//* GET ALL PRODUCT BY BRAND
                  "${brandController.choosedBrand.value.id}"),
          builder: (context, snapshot1) {
            if (snapshot1.connectionState == ConnectionState.done) {
              if (snapshot1.hasData) {
                List<ProductModel> listProducts = snapshot1.data!;
                if (status == 'Name') {
                  listProducts.sort(((a, b) => a.name.compareTo(b.name)));
                } else if (status == 'Higher Price') {
                } else if (status == 'Lower Price') {
                } else if (status == 'Sale') {
                  listProducts
                      .sort(((a, b) => b.discount!.compareTo(a.discount!)));
                }

                return TGridLayout(
                    itemCount: snapshot1.data!.length,
                    itemBuilder: (_, index) => FutureBuilder(
                        future: variantController.getVariantByIDs(
                            //* GET ALL VARIANTS BY PRODUCT IDS
                            listProducts[index].variants_path),
                        builder: (context, snapshot2) {
                          if (snapshot2.connectionState ==
                              ConnectionState.done) {
                            if (snapshot2.hasData) {
                              List<ProductVariantModel> listVariants =
                                  snapshot2.data!;
                              return TProductCardVertical(
                                  modelDetail: DetailProductModel(
                                      brand: brandController.choosedBrand.value,
                                      listVariants: listVariants,
                                      product: listProducts[index]));
                            } else if (snapshot2.hasError) {
                              return Center(
                                  child: Text(snapshot2.error.toString()));
                            } else {
                              return const Center(
                                  child: Text("smt went wrong"));
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }));
              } else if (snapshot1.hasError) {
                return Center(child: Text(snapshot1.error.toString()));
              } else {
                return const Center(child: Text("smt went wrong"));
              }
            } else {
              return const CircularProgressIndicator();
            }
          });
    } else if (type == 'popular') {
      showWidget = TGridLayout(
          itemCount: productController.listPopular.length,
          itemBuilder: (_, index) => TProductCardVertical(
              modelDetail: productController.listPopular[index]));
    }
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
        showWidget
      ],
    );
  }
}
