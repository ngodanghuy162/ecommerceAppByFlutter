import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/product_review_model/product_review_model.dart';
import 'package:ecommerce_app_mobile/Service/Model/product_review_model/reply_review_model.dart';
import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/authentication_repository.dart';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/ratings/rating_indicator.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_review_controller/reply_review_controller.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

class UserReviewCard extends StatefulWidget {
  const UserReviewCard({
    super.key,
    required this.review,
    required this.productId,
    this.reply,
    required this.shopEmail,
    required this.didPop,
  });

  final ProductReviewModel review;
  final ReplyReviewModel? reply;
  final String productId;
  final String shopEmail;
  final void Function() didPop;

  @override
  State<UserReviewCard> createState() => _UserReviewCardState();
}

class _UserReviewCardState extends State<UserReviewCard> {

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserRepository());
    final authRepo = Get.put(AuthenticationRepository());
    final replyController = Get.put(ReplyReviewController());
    TextEditingController commentController = TextEditingController();
    final dark = THelperFunctions.isDarkMode(context);

    Future<void> addReply(String reviewId) async {
      String content = commentController.text;
      String? shopEmail = authRepo.firebaseUser.value?.email;
      if (content.isNotEmpty) {
        ReplyReviewModel newReplyReview = ReplyReviewModel(
          content: content,
          date: Timestamp.fromDate(DateTime.now()),
          shopEmail: shopEmail!,
          reviewId: reviewId,
        );
        await replyController.createReplyReview(newReplyReview, widget.productId);
        // Get.to(() => ProductReviewsScreen()); //! điều hướng sau
      }
    }

    void _showBottomModal(BuildContext context, String reviewId) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [

                const SizedBox(height: TSizes.spaceBtwSections),

                // Text field for review content
                TextField(
                  controller: commentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: TColors.darkerGrey,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: TColors.darkerGrey,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    hintText: 'Nhập phản hồi của bạn',
                  ),
                ),

                const SizedBox(height: TSizes.spaceBtwSections),

                // Submit button or any other actions
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Đặt độ cong cho viền của nút
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24.0), // Đặt khoảng cách giữa chữ và viền
                    ),
                    child: const Text(
                      'Trở lại',
                      style: TextStyle(color: TColors.black),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwSections),
                  ElevatedButton(
                    onPressed: () async {
                      // Add logic to submit the reply
                      await addReply(reviewId);
                      widget.didPop();
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Đặt độ cong cho viền của nút
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24.0), // Đặt khoảng cách giữa chữ và viền
                    ),
                    child: const Text(
                      'Hoàn thành',
                    ),
                  ),
                ]),
              ],
            ),
          );
        },
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder(
              future: userController.getUserDetails(widget.review.userEmail),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    UserModel user = snapshot.data!;

                    return Row(
                      children: [
                        // const CircleAvatar(
                        //     backgroundImage: AssetImage(TImages.userProfileImage1)),
                        CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                user.avatar_imgURL!)),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Text('${user.lastName} ${user.firstName}',
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleLarge)
                      ],
                    );
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                  }
                }
                return const CircularProgressIndicator();
              },
            ),
            IconButton(onPressed: () {
              if(authRepo.firebaseUser.value!.email == widget.shopEmail) {
                _showBottomModal(context, widget.review.id!);
              } else {
                Get.snackbar(
                  'Thông báo',
                  'Bạn không phải là người bán sản phẩm này.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent.withOpacity(0.1),
                  animationDuration: const Duration(milliseconds: 500),
                  duration: const Duration(seconds: 1),
                  colorText: Colors.red,
                );
              }
            },
                icon: const Icon(Icons.more_vert)),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),

        /// Review
        Row(
          children: [
            TRatingBarIndicator(rating: widget.review.rating),
            const SizedBox(width: TSizes.spaceBtwItems),
            Text(widget.review.formattedDate,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium)
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Container(
          alignment: Alignment.centerLeft,
          child: ReadMoreText(
            //"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. In nibh mauris cursus mattis. Consectetur purus ut faucibus pulvinar. Fermentum posuere urna nec tincidunt praesent semper. Mauris pellentesque pulvinar pellentesque habitant morbi tristique. Bibendum enim facilisis gravida neque convallis. Aenean pharetra magna ac placerat vestibulum lectus mauris ultrices eros. Porttitor eget dolor morbi non. Mauris pellentesque pulvinar pellentesque habitant morbi. At augue eget arcu dictum varius. Massa tempor nec feugiat nisl pretium fusce. Viverra tellus in hac habitasse platea dictumst vestibulum rhoncus.",
              widget.review.content,
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
        if (widget.reply != null)
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
                          future:
                          userController.getUserDetails(
                              widget.reply!.shopEmail),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                UserModel shop = snapshot.data!;

                                return Text(
                                  '${shop.lastName} ${shop.firstName}',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,
                                );
                              } else if (snapshot.hasError) {
                                print(snapshot.error);
                              }
                            }
                            return const CircularProgressIndicator();
                          },
                        ),
                        Text(
                          widget.reply!.formattedDate,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: ReadMoreText(
                        //"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. In nibh mauris cursus mattis. Consectetur purus ut faucibus pulvinar. Fermentum posuere urna nec tincidunt praesent semper. Mauris pellentesque pulvinar pellentesque habitant morbi tristique. Bibendum enim facilisis gravida neque convallis. Aenean pharetra magna ac placerat vestibulum lectus mauris ultrices eros. Porttitor eget dolor morbi non. Mauris pellentesque pulvinar pellentesque habitant morbi. At augue eget arcu dictum varius. Massa tempor nec feugiat nisl pretium fusce. Viverra tellus in hac habitasse platea dictumst vestibulum rhoncus.",
                          widget.reply!.content,
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
                              color: TColors.primary)),
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
