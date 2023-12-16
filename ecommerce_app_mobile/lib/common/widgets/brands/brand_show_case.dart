import 'package:ecommerce_app_mobile/common/widgets/brands/brand_card.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class TBrandShowcase extends StatelessWidget {
  const TBrandShowcase({
    super.key,
    required this.brand,
    required this.listVariant,
  });

  final BrandModel brand;
  final List<ProductVariantModel> listVariant;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      showBorder: true,
      borderColor: TColors.darkGrey,
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.all(TSizes.md),
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      child: Column(
        children: [
          /// Brands with Products Count
          TBrandCard(showBorder: false, brand: brand),
          const SizedBox(height: TSizes.spaceBtwItems),

          /// Brand Top 3 Product Images
          Row(
              children: listVariant.length <= 3
                  ? listVariant
                      .map((variant) =>
                          brandTopProductImageWidget(variant.imageURL, context))
                      .toList()
                  : [
                      brandTopProductImageWidget(
                          listVariant[0].imageURL, context),
                      brandTopProductImageWidget(
                          listVariant[1].imageURL, context),
                      brandTopProductImageWidget(
                          listVariant[2].imageURL, context)
                    ]),
        ],
      ),
    );
  }

  Widget brandTopProductImageWidget(String imageURL, context) {
    return Expanded(
      child: TRoundedContainer(
        height: 100,
        padding: const EdgeInsets.all(TSizes.md),
        margin: const EdgeInsets.only(right: TSizes.sm),
        backgroundColor: THelperFunctions.isDarkMode(context)
            ? TColors.darkGrey
            : TColors.light,
        child: Image.network(
          imageURL,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
