import 'package:ecommerce_app_mobile/common/styles/product_price_text.dart';
import 'package:ecommerce_app_mobile/common/styles/t_brand_title_text_with_verified_icon.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_history_order/widgets/product_history_item.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/enums.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ProductOrderCard extends StatelessWidget {
  const ProductOrderCard({super.key, this.showReviewModal});

  final void Function(BuildContext context)? showReviewModal;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
      onTap: () {},
      child: TRoundedContainer(
        width: double.infinity,
        showBorder: true,
        padding: const EdgeInsets.all(TSizes.md),
        backgroundColor: Colors.transparent,
        borderColor: THelperFunctions.isDarkMode(context)
            ? TColors.darkGrey
            : TColors.grey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TBrandTitleWithVerifiedIcon(
                    title: 'Adidas',
                    isVerified: true,
                    brandTextSize: TextSizes.large,
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      'Processing',
                      style: Theme.of(context).textTheme.bodyLarge!.apply(
                            color: TColors.primary.withOpacity(
                              0.7,
                            ),
                            fontWeightDelta: 1,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const ProductOrderItem(
              brand: 'adidas',
              color: Colors.green,
              imgUrl:
                  'https://cdn.thewirecutter.com/wp-content/media/2023/05/running-shoes-2048px-9718.jpg',
              size: 'ÚK',
              title: 'Day la title cua san pham Day la title cua san pham .',
            ),
            const SizedBox(height: TSizes.sm),
            const Divider(
              height: 10,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: TColors.divider,
            ),
            Text(
              'Xem them san pham',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const Divider(
              height: 10,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: TColors.divider,
            ),
            Row(
              children: [
                Text('2 products',
                    style: Theme.of(context).textTheme.bodyMedium),
                const Spacer(),
                Text(
                  'Total: ',
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                TProductPriceText(
                  price: '60',
                  color: TColors.primary.withOpacity(0.7),
                ),
              ],
            ),
            if (showReviewModal != null)
              const Divider(
                height: 10,
                thickness: 1,
                indent: 0,
                endIndent: 0,
                color: TColors.divider,
              ),
            if (showReviewModal != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => showReviewModal!(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24.0,
                        ), // Đặt khoảng cách giữa chữ và viền
                      ),
                      child: const Text(
                        'Danh gia',
                      ),
                    )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
