import 'package:ecommerce_app_mobile/common/widgets/image_text_widgets/vertical_image_text.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/sub_category/sub_category_screen.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class THomeCategories extends StatelessWidget {
  const THomeCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 6,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          return TVerticalImageText(
              image: TImages.shoeIcon,
              title: 'Shoe',
              onTap: () => Get.to(() => const SubCategoryScreen()));
        },
      ),
    );
  }
}
