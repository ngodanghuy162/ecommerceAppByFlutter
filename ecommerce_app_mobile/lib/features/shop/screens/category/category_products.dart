import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_category_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/detail_product_model.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryProducts extends StatelessWidget {
  CategoryProducts({super.key, required this.listCategories});
  final categoriesController = Get.put(ProductCategoryController());
  final List<DetailProductModel> listCategories;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TAppBar(
          title: Text(categoriesController.choosedCategories.value),
          showBackArrow: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              TGridLayout(
                  itemCount: listCategories.length,
                  itemBuilder: (_, index) =>
                      TProductCardVertical(modelDetail: listCategories[index]))
            ],
          ),
        ));
  }
}
