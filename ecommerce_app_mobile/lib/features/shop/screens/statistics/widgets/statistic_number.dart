import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class StatisticNumber extends StatelessWidget {
  const StatisticNumber({
    required this.text,
    required this.color,
    required this.number,
    super.key,
  });

  final String text;
  final Color? color;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        Text('$number')
      ],
    );
  }
}
