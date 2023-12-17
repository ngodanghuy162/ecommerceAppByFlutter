import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class TVerticalImageText extends StatelessWidget {
  const TVerticalImageText({
    super.key,
    required this.title,
    this.textColor = TColors.white,
    this.backgroundColor,
    this.onTap,
  });

  final String title;

  final Color textColor;
  final Color? backgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    String image = TImages.shoeIcon;
    if (title == 'Clothes') {
      image = TImages.clothIcon;
    } else if (title == 'Sport') {
      image = TImages.sportIcon;
    } else if (title == 'Toy') {
      image = TImages.toyIcon;
    } else if (title == 'Furniture') {
      image = TImages.furnitureIcon;
    } else if (title == 'Cosmetics') {
      image = TImages.cosmeticsIcon;
    } else if (title == 'Jewelery') {
      image = TImages.jeweleryIcon;
    } else if (title == 'Shoe') {
      image = TImages.shoeIcon;
    } else if (title == 'Electronics') {
      image = TImages.electronicsIcon;
    }

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: TSizes.spaceBtwItems),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(TSizes.sm),
              decoration: BoxDecoration(
                color:
                    backgroundColor ?? (dark ? TColors.black : TColors.white),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Image(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                  color: dark ? TColors.light : TColors.dark,
                ),
              ),
            ),

            /// Text
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            SizedBox(
                width: 55,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .apply(color: textColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ))
          ],
        ),
      ),
    );
  }
}
