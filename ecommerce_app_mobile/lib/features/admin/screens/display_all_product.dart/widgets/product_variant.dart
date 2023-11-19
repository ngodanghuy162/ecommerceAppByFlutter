import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ProductVariant extends StatelessWidget {
  const ProductVariant({
    super.key,
    required this.color,
    required this.size,
    required this.price,
    required this.inStock,
  });

  final String color;
  final String size;
  final String price;
  final String inStock;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return ListTile(
      title: Card(
        color: isDark ? TColors.darkContainer : TColors.lightContainer,
        child: Padding(
          padding: const EdgeInsets.all(TSizes.cardRadiusSm),
          child: Row(
            children: [
              Text(
                color,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Text(
                size,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Text(
                inStock,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Text(
                price,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
