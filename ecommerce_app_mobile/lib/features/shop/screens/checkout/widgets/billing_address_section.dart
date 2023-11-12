import 'package:ecommerce_app_mobile/common/widgets/texts/section_heading.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TBillingAddressSection extends StatelessWidget {
  const TBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TSectionHeading(
          title: "Shipping Address",
          buttonTitle: "Change",
          onPressed: () {},
        ),
        Text(
          "NgoHuyDepTrai",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Row(
          children: [
            const Icon(
              Icons.phone,
              color: Colors.green,
              size: 16,
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            Text(
              "034555555",
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
        const SizedBox(width: TSizes.spaceBtwItems / 2),
        Row(
          children: [
            const Icon(
              Icons.location_history,
              color: Colors.green,
              size: 16,
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            Expanded(
                child: Text(
              "Hanoi, VietNam, DNA",
              style: Theme.of(context).textTheme.bodyMedium,
              softWrap: true,
            ))
          ],
        )
      ],
    );
  }
}
