import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/chat/chatting_screen.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_controller.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TRatingAndShare extends StatelessWidget {
  const TRatingAndShare({
    super.key,
    required this.overall,
    required this.reviewLength,
    required this.variant,
    required this.product,
    required this.maxPrice,
    required this.minPrice,
    required this.discount,
  });

  final double overall;
  final int reviewLength;
  final ProductVariantModel variant;
  final ProductModel product;
  final double maxPrice;
  final double minPrice;
  final int discount;

  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Ration
        Row(
          children: [
            const Icon(Iconsax.star5, color: Colors.amber, size: 24,),
            const SizedBox(width: TSizes.spaceBtwItems / 2,),
            Text.rich(
                TextSpan(
                    children: [
                      TextSpan(text: '${overall.toStringAsFixed(1)} ', style: Theme.of(context).textTheme.bodyLarge),
                      TextSpan(text: '($reviewLength)'),
                    ]
                )
            )
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /// Chat Button
            IconButton(onPressed: () => Get.to(() => ChattingScreen(
              variant: variant,
              product: product,
              maxPrice: maxPrice,
              minPrice: minPrice,
              discount: discount,
            )), icon: const Icon(Icons.chat, size: TSizes.iconMd,)),
            /// Share Button
            IconButton(onPressed: () {}, icon: const Icon(Icons.share, size: TSizes.iconMd,))
          ],
        ),
      ],
    );
  }
}