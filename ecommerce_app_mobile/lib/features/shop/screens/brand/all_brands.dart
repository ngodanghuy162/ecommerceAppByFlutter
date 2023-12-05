import 'package:ecommerce_app_mobile/common/styles/section_heading.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/brands/brand_card.dart';
import 'package:ecommerce_app_mobile/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/brands_controller/brands_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/brands/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/brand/brand_products.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllBrandsScreen extends StatelessWidget {
  AllBrandsScreen({super.key});

  final controller = Get.put(BrandsController());

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
                        return TGridLayout(
                          itemCount: snapshot.data!.length,
                          mainAxisExtent: 80,
                          itemBuilder: (context, index) => TBrandCard(
                            showVerify: snapshot.data![index].isVerified,
                            nameBrand: snapshot.data![index].name,
                            showBorder: true,
                            onTap: () => Get.to(() => BrandProducts(
                                  brand: snapshot.data![index],
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
