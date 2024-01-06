import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/images/t_circular_image.dart';
import 'package:ecommerce_app_mobile/common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/enums.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TBrandCard extends StatelessWidget {
  TBrandCard({
    super.key,
    required this.showBorder,
    this.onTap,
    required this.brand,
  });

  final bool showBorder;
  final void Function()? onTap;

  final BrandModel brand;
  final productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final isDark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,

      /// Container Design
      child: TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.sm),
        showBorder: showBorder,
        backgroundColor: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Icon
            Flexible(
              child: TCircularImage(
                isNetworkImage: true,
                image: brand.imageUrl!,
                // isNetworkImage: false,
                // image: TImages.clothIcon,
                backgroundColor: Colors.transparent,
                overlayColor: THelperFunctions.isDarkMode(context)
                    ? TColors.white
                    : TColors.black,
              ),
            ),
            const SizedBox(
              width: TSizes.spaceBtwItems / 2,
            ),

            /// Text
            Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  TBrandTitleWithVerifiedIcon(
                    showVerify: brand.isVerified,
                    title: brand.name,
                    brandTextSize: TextSizes.large,
                  ),
                  FutureBuilder(
                      future: productController.getAllProductbyBrand(brand.id!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return Text(
                              "${snapshot.data!.length} products",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelMedium,
                            );
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
                ]))
          ],
        ),
      ),
    );
  }
}
