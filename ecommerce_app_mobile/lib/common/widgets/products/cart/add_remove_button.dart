import 'package:ecommerce_app_mobile/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TProductQuantityWithAddAndRemove extends StatefulWidget {
  int quantity;
  TProductQuantityWithAddAndRemove({
    required this.quantity,
    super.key,
  });

  @override
  State<TProductQuantityWithAddAndRemove> createState() =>
      _TProductQuantityWithAddAndRemoveState();
}

class _TProductQuantityWithAddAndRemoveState
    extends State<TProductQuantityWithAddAndRemove> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TCircularIcon(
          icon: Iconsax.minus,
          width: 32,
          height: 32,
          size: TSizes.md,
          color: THelperFunctions.isDarkMode(context)
              ? TColors.white
              : TColors.black,
          backgroundColor: THelperFunctions.isDarkMode(context)
              ? TColors.darkerGrey
              : TColors.light,
          onPressed: () {
            setState(() {
              widget.quantity++;
            });
          },
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        Text(widget.quantity.toString()),
        const SizedBox(width: TSizes.spaceBtwItems),
        const TCircularIcon(
          icon: Iconsax.add,
          width: 32,
          height: 32,
          size: TSizes.md,
          color: TColors.white,
          backgroundColor: TColors.primary,
        ),
      ],
    );
  }
}
