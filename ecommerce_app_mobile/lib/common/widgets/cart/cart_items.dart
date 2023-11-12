import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TCartItems extends StatelessWidget {
  const TCartItems({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: 10,
        separatorBuilder: (_, __) => const SizedBox(
              height: TSizes.spaceBtwSections,
            ),
        itemBuilder: (_, index) => const Column(
          children: [
            
          ],
        ));
  }
}
