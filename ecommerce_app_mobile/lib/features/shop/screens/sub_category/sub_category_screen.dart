import 'package:ecommerce_app_mobile/common/styles/section_heading.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_app_mobile/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/brand_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_category_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_variant_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/detail_product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/category/category_products.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubCategoryScreen extends StatelessWidget {
  SubCategoryScreen({super.key, required this.categoryName});
  final String categoryName;

  final categoriesController = Get.put(ProductCategoryController());
  final brandController = Get.put(BrandController());
  final productController = Get.put(ProductController());
  final variantController = Get.put(ProductVariantController());

  @override
  Widget build(BuildContext context) {
    categoriesController.listCategoryProducts = [];
    return Scaffold(
      appBar: TAppBar(
        title: Text(categoryName),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              //banner
              const TRoundedImage(
                width: double.infinity,
                imageUrl: TImages.promoBanner3,
                applyImageRadius: true,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              //sub-category
              Column(
                children: [
                  //heading
                  TSectionHeading(
                    title: categoryName,
                    onPressed: () => Get.to(() => CategoryProducts(
                        listCategories:
                            categoriesController.listCategoryProducts)),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  FutureBuilder(
                      future: categoriesController
                          .getCategoryDocumentIdByName(categoryName),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            String categoryID = snapshot.data! as String;
                            return FutureBuilder(
                                future: productController
                                    .getProductByCategory(categoryID),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      List listProducts = snapshot.data!;
                                      int lenghtShow = listProducts.length > 6
                                          ? 6
                                          : listProducts.length;
                                      return TGridLayout(
                                        itemCount: lenghtShow,
                                        itemBuilder: (_, index) =>
                                            FutureBuilder(
                                                future: Future.wait([
                                                  brandController.getBrandById(
                                                      listProducts[index]
                                                          .brand_id),
                                                  variantController
                                                      .getVariantByIDs(
                                                          listProducts[index]
                                                              .variants_path),
                                                ]),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    if (snapshot.hasData) {
                                                      var brand =
                                                          snapshot.data![0]
                                                              as BrandModel;
                                                      var listVariants = snapshot
                                                              .data![1]
                                                          as List<
                                                              ProductVariantModel>;
                                                      DetailProductModel model =
                                                          DetailProductModel(
                                                              brand: brand,
                                                              product:
                                                                  listProducts[
                                                                      index],
                                                              listVariants:
                                                                  listVariants);
                                                      categoriesController
                                                          .listCategoryProducts
                                                          .add(model);
                                                      categoriesController
                                                          .listCategoryProducts
                                                          .sort(((a, b) => a
                                                              .product.name
                                                              .compareTo(b
                                                                  .product
                                                                  .name)));
                                                      return TProductCardVertical(
                                                          modelDetail: model);
                                                      // return Container();
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Center(
                                                          child: Text(snapshot
                                                              .error
                                                              .toString()));
                                                    } else {
                                                      return const Center(
                                                          child: Text(
                                                              "smt went wrong"));
                                                    }
                                                  } else {
                                                    return const CircularProgressIndicator();
                                                  }
                                                }),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text(snapshot.error.toString()));
                                    } else {
                                      return Center(
                                          child: Text("smt went wrong"));
                                    }
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                });
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(snapshot.error.toString()));
                          } else {
                            return Center(child: Text("smt went wrong"));
                          }
                        } else {
                          return const CircularProgressIndicator();
                        }
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
