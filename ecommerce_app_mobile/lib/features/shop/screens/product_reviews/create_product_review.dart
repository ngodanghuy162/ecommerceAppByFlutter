import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/product_review_model/product_review_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/authentication_repository.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_review_controller/product_review_controller.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

//! Sau này có trang đơn hang đã mua thì ghép vào sau
class CreateProductReview extends StatefulWidget {
  const CreateProductReview({super.key, required this.productId});

  @override
  State<CreateProductReview> createState() => _CreateProductReviewState();
  final String productId;
}

class _CreateProductReviewState extends State<CreateProductReview> {
  TextEditingController commentController = TextEditingController();
  final reviewController = Get.put(ProductReviewController());
  final _authRepo = Get.put(AuthenticationRepository());
  late double finalRating;

  Future<void> addReview() async {
    String content = commentController.text;
    String? userEmail = _authRepo.firebaseUser.value?.email;
    if (content.isNotEmpty) {
      ProductReviewModel newReview = ProductReviewModel(
        rating: finalRating,
        userEmail: userEmail as String,
        content: content,
        date: Timestamp.fromDate(DateTime.now()),
      );
      await reviewController.createReview(newReview, widget.productId);
      // Get.to(() => ProductReviewsScreen()); //! điều hướng sau
    }
  }

  void _showBottomModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Star ratings widget (you can use your own star rating widget)
              // Replace the following line with your actual star rating widget
              const Text('Có thể là thông tin về sản phẩm'),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Chất lượng sản phẩm:'),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  RatingBar.builder(
                    initialRating: 5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      finalRating = rating;
                    },
                  ),
                ],
              ),

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
                  hintText: 'Nhập bình luận của bạn',
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
                    // Add logic to submit the review
                    await addReview();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(title: Text('Review Product'), showBackArrow: true),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  _showBottomModal(context);
                },
                child: const Text('Tạo đánh giá'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
