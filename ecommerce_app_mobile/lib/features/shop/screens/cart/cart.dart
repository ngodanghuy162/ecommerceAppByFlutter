import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Cart',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return const SizedBox(height: TSizes.spaceBtwSections);
            },
            itemCount: 4,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(
                    children: [
                      //Image
                      TRoundImage(
                        imageUrl: TImages.productImage1,
                        width: 60,
                        height: 60,
                        padding: const EdgeInsets.all(TSizes.sm),
                        backgroundColor: THelperFunctions.isDarkMode(context)
                            ? TColors.darkerGrey
                            : TColors.light,
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),

                      //Title, price, sizes
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
