import 'package:ecommerce_app_mobile/common/styles/shadows.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_app_mobile/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TProductCardVertical extends StatelessWidget {
  const TProductCardVertical({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Container(
      width: 180,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
          boxShadow: [TShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: dark ? TColors.darkerGrey : TColors.white),
      child: Column(children: [
        // Thumbnail, Wishlist, Button, Discount Tag
        TRoundedContainer(
          height: 180,
          padding: const EdgeInsets.all(TSizes.sm),
          backgroundColor: dark ? TColors.dark : TColors.light,
          child: Stack(children: [
            // -- Thumbnail Image
            const TRoundedImage(
              imageUrl: TImages.productImage1,
              applyImageRadius: true,
            ),

            // -- Sale Tag
            Positioned(
              top: 12,
              child: TRoundedContainer(
                radius: TSizes.sm,
                backgroundColor: TColors.secondary.withOpacity(0.8),
                padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.sm, vertical: TSizes.xs),
                child: Text('25%',
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                          color: TColors.black,
                        )),
              ),
            ),
            TCircularIcon(
              icon: Iconsax.heart5,
              color: Colors.red,
            )
          ]),
        ),
      ]),
    );
  }
}
