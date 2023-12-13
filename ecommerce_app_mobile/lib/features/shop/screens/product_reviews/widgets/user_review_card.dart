import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_mobile/Service/Model/product_review_model/product_review_model.dart';
import 'package:ecommerce_app_mobile/Service/Model/product_review_model/reply_review_model.dart';
import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:ecommerce_app_mobile/Service/Repository/user_repository.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/ratings/rating_indicator.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({
    super.key,
    required this.review,
    this.reply,
  });

  final ProductReviewModel review;
  final ReplyReviewModel? reply;

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserRepository());

    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder(
              future: userController.getUserDetails(review.userEmail),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done) {
                  if(snapshot.hasData) {
                    UserModel user = snapshot.data!;

                    return Row(
                      children: [
                        // const CircleAvatar(
                        //     backgroundImage: AssetImage(TImages.userProfileImage1)),
                        CircleAvatar(backgroundImage: CachedNetworkImageProvider(user.avatar_imgURL)),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Text('${user.lastName} ${user.firstName}', style: Theme.of(context).textTheme.titleLarge)
                      ],
                    );
                  } else if(snapshot.hasError) {
                    print(snapshot.error);
                  }
                }
                return const CircularProgressIndicator();
              },
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),

        /// Review
        Row(
          children: [
            TRatingBarIndicator(rating: review.rating),
            const SizedBox(width: TSizes.spaceBtwItems),
            Text(review.formattedDate, style: Theme.of(context).textTheme.bodyMedium)
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Container(
          alignment: Alignment.centerLeft,
          child: ReadMoreText(
              //"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. In nibh mauris cursus mattis. Consectetur purus ut faucibus pulvinar. Fermentum posuere urna nec tincidunt praesent semper. Mauris pellentesque pulvinar pellentesque habitant morbi tristique. Bibendum enim facilisis gravida neque convallis. Aenean pharetra magna ac placerat vestibulum lectus mauris ultrices eros. Porttitor eget dolor morbi non. Mauris pellentesque pulvinar pellentesque habitant morbi. At augue eget arcu dictum varius. Massa tempor nec feugiat nisl pretium fusce. Viverra tellus in hac habitasse platea dictumst vestibulum rhoncus.",
              review.content,
              trimLines: 1,
              trimMode: TrimMode.Line,
              trimExpandedText: ' show less',
              trimCollapsedText: ' show more',
              moreStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: TColors.primary),
              lessStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: TColors.primary)),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),

        /// Company Review
        if(reply != null)
        TRoundedContainer(
          backgroundColor: dark ? TColors.darkerGrey : TColors.grey,
          child: Padding(
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder(
                        future: userController.getUserDetails(reply!.shopEmail),
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.done) {
                            if(snapshot.hasData) {
                              UserModel shop = snapshot.data!;

                              return Text(
                                '${shop.lastName} ${shop.firstName}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              );
                            } else if(snapshot.hasError) {
                              print(snapshot.error);
                            }
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                      Text(
                        reply!.formattedDate,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: ReadMoreText(
                        //"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. In nibh mauris cursus mattis. Consectetur purus ut faucibus pulvinar. Fermentum posuere urna nec tincidunt praesent semper. Mauris pellentesque pulvinar pellentesque habitant morbi tristique. Bibendum enim facilisis gravida neque convallis. Aenean pharetra magna ac placerat vestibulum lectus mauris ultrices eros. Porttitor eget dolor morbi non. Mauris pellentesque pulvinar pellentesque habitant morbi. At augue eget arcu dictum varius. Massa tempor nec feugiat nisl pretium fusce. Viverra tellus in hac habitasse platea dictumst vestibulum rhoncus.",
                        reply!.content,
                        textAlign: TextAlign.left,
                        trimLines: 2,
                        trimMode: TrimMode.Line,
                        trimExpandedText: ' show less',
                        trimCollapsedText: ' show more',
                        moreStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: TColors.primary),
                        lessStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: TColors.primary)
                    ),
                  ),
                ],
              )),
        ),
        const SizedBox(
          height: TSizes.spaceBtwSections,
        )
      ],
    );
  }
}
