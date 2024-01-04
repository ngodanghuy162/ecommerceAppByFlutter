import 'package:flutter/material.dart';

class TProductPriceText extends StatelessWidget {
  const TProductPriceText({
    super.key,
    this.currencySign = '\$',
    required this.price,
    this.maxLines = 1,
    this.isLarge = false,
    this.lineThrough = false,
    this.color,
  });

  final String currencySign, price;
  final int maxLines;
  final bool isLarge, lineThrough;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      currencySign + price,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: isLarge
          ? Theme.of(context).textTheme.headlineMedium!.apply(
                decoration: lineThrough ? TextDecoration.lineThrough : null,
                color: color,
              )
          : Theme.of(context).textTheme.bodyMedium!.apply(
                decoration: lineThrough ? TextDecoration.lineThrough : null,
                color: color,
              ),
    );
  }
}
