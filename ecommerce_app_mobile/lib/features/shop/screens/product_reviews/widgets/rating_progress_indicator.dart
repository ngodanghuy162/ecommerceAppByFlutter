import 'package:ecommerce_app_mobile/features/shop/screens/product_reviews/widgets/progress_indicator_and_rating.dart';
import 'package:flutter/material.dart';

class TOverallProductRating extends StatelessWidget {
  const TOverallProductRating({
    super.key,
    required this.fiveStarRate,
    required this.fourStarRate,
    required this.threeStarRate,
    required this.twoStarRate,
    required this.oneStarRate,
    required this.overall
  });

  final double fiveStarRate;
  final double fourStarRate;
  final double threeStarRate;
  final double twoStarRate;
  final double oneStarRate;
  final double overall;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child:
                Text(overall.toStringAsFixed(1), style: Theme.of(context).textTheme.displayLarge)),
        Expanded(
          flex: 7,
          child: Column(children: [
            TRatingProgressIndicator(text: "5", value: fiveStarRate),
            TRatingProgressIndicator(text: "4", value: fourStarRate),
            TRatingProgressIndicator(text: "3", value: threeStarRate),
            TRatingProgressIndicator(text: "2", value: twoStarRate),
            TRatingProgressIndicator(text: "1", value: oneStarRate)
          ]),
        )
      ],
    );
  }
}
