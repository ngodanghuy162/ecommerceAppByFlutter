import 'package:ecommerce_app_mobile/common/widgets/texts/section_heading.dart';
import 'package:ecommerce_app_mobile/features/personalization/screens/address/address.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TBillingAddressSection extends StatelessWidget {
  const TBillingAddressSection(
      {super.key,
      required this.name,
      required this.phoneNumber,
      required this.fullAddress,
      this.showChangeButton = true});

  final String name;
  final String phoneNumber;
  final String fullAddress;
  final bool showChangeButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TSectionHeading(
          title: "Shipping Address",
          buttonTitle: "Change",
          onPressed: showChangeButton
              ? () {
                  Future.delayed(const Duration(seconds: 0), () {
                    Get.to(() => const UserAddressScreen());
                  });
                }
              : null,
        ),
        Text(
          name,
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
              phoneNumber,
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
              fullAddress,
              style: Theme.of(context).textTheme.bodyMedium,
              softWrap: true,
            ))
          ],
        )
      ],
    );
  }
}
