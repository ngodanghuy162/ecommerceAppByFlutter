import 'package:ecommerce_app_mobile/common/styles/section_heading.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/brands/brand_card.dart';
import 'package:ecommerce_app_mobile/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/brand_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/brand/brand_products.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllBrandsScreen extends StatelessWidget {
  AllBrandsScreen({super.key});

  final controller = Get.put(BrandController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        title: Text('Brand'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// Heading
              const TSectionHeading(title: 'Brands'),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              FutureBuilder(
                  future: controller.getAllBrandsData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        List<BrandModel> listProducts = snapshot.data!;
                        listProducts.sort(((a, b) => a.name.compareTo(b.name)));
                        listProducts.sort((a, b) {
                          if (a.isVerified && !b.isVerified) {
                            return -1; // Put completed objects first
                          } else if (!a.isVerified && b.isVerified) {
                            return 1; // Put non-completed objects last
                          }
                          return 0; // Equal
                        });
                        return TGridLayout(
                          itemCount: snapshot.data!.length,
                          mainAxisExtent: 80,
                          itemBuilder: (context, index) => TBrandCard(
                            brand: snapshot.data![index],
                            showBorder: true,
                            onTap: () => Get.to(() => BrandProducts(
                                  brand: listProducts[index],
                                )),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      } else {
                        return const Center(child: Text("smt went wrong"));
                      }
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),

              /// Brands
            ],
          ),
        ),
      ),
    );
  }
}
