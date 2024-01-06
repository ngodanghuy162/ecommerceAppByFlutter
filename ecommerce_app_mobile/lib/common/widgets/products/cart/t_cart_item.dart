import 'package:ecommerce_app_mobile/common/styles/product_title_text.dart';
import 'package:ecommerce_app_mobile/common/styles/t_brand_title_text_with_verified_icon.dart';
import 'package:ecommerce_app_mobile/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class TCartItem extends StatelessWidget {
  final String? brand;
  final String? imgUrl;
  final String? title;
  final Color? color;
  final String? size;
  const TCartItem({
    this.brand,
    this.title,
    this.imgUrl,
    this.color,
    this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //Image
        TRoundedImage(
          imageUrl: imgUrl!,
          isNetworkImage: true,
          width: 100,
          height: 100,
          padding: const EdgeInsets.all(TSizes.sm),
          backgroundColor: THelperFunctions.isDarkMode(context)
              ? TColors.darkerGrey
              : TColors.light,
        ),
        const SizedBox(width: TSizes.spaceBtwItems),

        //Title, price, sizes
        //Branch title with verified
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TBrandTitleWithVerifiedIcon(title: brand!),
              Flexible(
                child: TProductTitleText(
                  title: title!,
                  maxLines: 1,
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Color ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    WidgetSpan(
                      child: Container(
                        width: 16,
                        height: 16,
                        margin: const EdgeInsets.only(
                          bottom: 2,
                          right: 5,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color ?? Colors.lightBlue,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: 'Sizes ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: size ?? "",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
