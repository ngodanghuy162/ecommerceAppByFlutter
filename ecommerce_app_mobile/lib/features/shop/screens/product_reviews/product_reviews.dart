import 'dart:async';
import 'package:ecommerce_app_mobile/Service/Model/product_review_model/product_review_model.dart';
import 'package:ecommerce_app_mobile/Service/Model/product_review_model/reply_review_model.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/ratings/rating_indicator.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_review_controller/product_review_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_review_controller/reply_review_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_reviews/widgets/rating_progress_indicator.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_reviews/widgets/user_review_card.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductReviewsScreen extends StatefulWidget {
  const ProductReviewsScreen({super.key, required this.product});
  final ProductModel product;

  @override
  State<ProductReviewsScreen> createState() => _ProductReviewsScreenState();
}

class _ProductReviewsScreenState extends State<ProductReviewsScreen> {

  // Cập nhật màn hình sau khi phản hồi
  void didPop() {
    // ignore: invalid_use_of_protected_member
    (context as Element).reassemble();
  }

  @override
  Widget build(BuildContext context) {
    final reviewController = Get.put(ProductReviewController());
    final replyController = Get.put(ReplyReviewController());

    late List<ProductReviewModel> reviewList;
    late List<ReplyReviewModel> replyList;

    late List<double> starRating = [];

    ReplyReviewModel? getReplyComments(String id) {
      var matchingReplies = replyList.where((e) => e.reviewId == id);
      return matchingReplies.isNotEmpty ? matchingReplies.first : null;
    }

    return Scaffold(
      appBar:
          const TAppBar(title: Text("Reviews & Rating"), showBackArrow: true),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: FutureBuilder(
          future: Future.wait([
            reviewController.getAllReview(widget.product.id!),
            replyController.getAllReplyReview(widget.product.id!)
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final data = snapshot.data!;

                reviewList = (data[0])
                    .map((dynamic item) => item as ProductReviewModel)
                    .toList();
                replyList = (data[1])
                    .map((dynamic item) => item as ReplyReviewModel)
                    .toList();

                if (reviewList.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Ratings and reviews are verifed and are from people who use the same type of device that you use"),
                      const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                      const TOverallProductRating(
                        oneStarRate: 0,
                        twoStarRate: 0,
                        threeStarRate: 0,
                        fourStarRate: 0,
                        fiveStarRate: 0,
                        overall: 0,
                      ),
                      const TRatingBarIndicator(rating: 0),
                      Text("0",
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      const Center(
                        child: Text("There are no reviews yet."),
                      ),
                    ]
                  );
                }

                for (int i = 0; i < 5; i++) {
                  // số lần xuất hiện
                  double number = 0;
                  for (int j = 0; j < reviewList.length; j++) {
                    if (reviewList[j].rating == (i + 1).toDouble()) {
                      number++;
                    }
                  }
                  double ratio = (number / reviewList.length).toDouble();
                  starRating.add(ratio);
                }

                double overall = 5 * starRating[4] +
                    4 * starRating[3] +
                    3 * starRating[2] +
                    2 * starRating[1] +
                    1 * starRating[0];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        "Ratings and reviews are verifed and are from people who use the same type of device that you use"),
                    const SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),

                    /// Overall Product Ratings
                    TOverallProductRating(
                      oneStarRate: starRating[0],
                      twoStarRate: starRating[1],
                      threeStarRate: starRating[2],
                      fourStarRate: starRating[3],
                      fiveStarRate: starRating[4],
                      overall: overall,
                    ),
                    TRatingBarIndicator(rating: overall),
                    Text("${reviewList.length}",
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    /// User Reviews list
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: reviewList.length,
                        itemBuilder: (context, index) {
                          return UserReviewCard(
                            review: reviewList[index],
                            reply: getReplyComments(reviewList[index].id!),
                            productId: widget.product.id!,
                            shopEmail: widget.product.shopEmail!,
                            didPop: didPop,
                          );
                        },
                      ),
                    ),
                    // const UserReviewCard(),
                    // const UserReviewCard(),
                    // const UserReviewCard(),
                    // const UserReviewCard(),
                  ],
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
