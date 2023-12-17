import 'package:ecommerce_app_mobile/common/widgets/image_text_widgets/vertical_image_text.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_category_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_category_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/sub_category/sub_category_screen.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class THomeCategories extends StatelessWidget {
  THomeCategories({
    super.key,
  });
  final categoriesController = Get.put(ProductCategoryController());
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: categoriesController.getAllCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<ProductCategoryModel> listCategories = snapshot.data!;
              listCategories.sort((a, b) => a.name.compareTo(b.name));
              return SizedBox(
                height: 80,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listCategories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    return TVerticalImageText(
                        title: listCategories[index].name,
                        onTap: () => Get.to(() => const SubCategoryScreen()));
                  },
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
        });
  }
}
