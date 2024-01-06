import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/texts/section_heading.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class TBillingPaymentSection extends StatelessWidget {
  const TBillingPaymentSection({super.key, this.showChangeButton = true});

  final bool showChangeButton;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      children: [
        TSectionHeading(
          title: "Payment Method",
          buttonTitle: "Change",
          onPressed: showChangeButton ? () {} : null,
        ),
        const SizedBox(
          height: TSizes.spaceBtwItems / 2,
        ),
        Row(
          children: [
            TRoundedContainer(
              width: 60,
              height: 35,
              backgroundColor: dark ? TColors.dark : TColors.white,
              padding: const EdgeInsets.all(TSizes.sm),
              child: const Image(
                image: AssetImage(TImages.paypal),
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems / 2,
            ),
            Text(
              "Paypal",
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],
        )
      ],
    );
  }
}
