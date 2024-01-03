import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/product_review_model/product_review_model.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_review_controller/product_review_controller.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../../../Service/repository/authentication_repository.dart';

class ProductHistoryOrder extends StatefulWidget {
  const ProductHistoryOrder({super.key});

  @override
  State<ProductHistoryOrder> createState() => _ProductHistoryOrderState();
}

class _ProductHistoryOrderState extends State<ProductHistoryOrder> {
  TextEditingController commentController = TextEditingController();
  final reviewController = Get.put(ProductReviewController());
  final _authRepo = Get.put(AuthenticationRepository());
  late double finalRating;

  void addReview() async {
    String content = commentController.text;
    String? userEmail = _authRepo.firebaseUser.value?.email;
    if (content.isNotEmpty) {
      ProductReviewModel newReview = ProductReviewModel(
        rating: finalRating,
        userEmail: userEmail as String,
        content: content,
        date: Timestamp.fromDate(DateTime.now()),
      );
      await reviewController.createReview(newReview);
      // Get.to(() => ProductReviewsScreen()); //! điều hướng sau
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        backgroundColor: TColors.primary,
        title: Text("History Order", style: TextStyle(color: TColors.white),),
        showBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.spaceBtwItems),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, index) {
            return _buildProductOrderCard(
            );
          },
        ),
      )
    );
  }

  Widget _buildProductOrderCard() {
    return InkWell(
      onTap: () {
        // Add logic to navigate to the detailed order screen
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: TColors.black, width: 1.0),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/e-commerce-uet-project.appspot.com/o/images%2F1702698393117.jpg?alt=media&token=24a5b3a4-db59-4251-ab3c-e5e4e4ae72d9',
                  width: 90.0,
                  height: 90.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sữa rửa mặt dưỡng ẩm',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Phân loại hàng: ',
                        style: TextStyle(color: Colors.grey[850]),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'x1 ',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 1),
                Text(
                  '155000VND',
                  style: const TextStyle(color: Colors.deepOrange, fontSize: 12),
                )
              ],
            ),

            const Divider(color: TColors.black),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add logic to navigate to the review screen
                    _showBottomModal(context);
                  },
                  child: Text('Đánh Giá'),
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(Colors.deepOrange),
                    padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.all(14)),
                  ),
                ),
                Text(
                  'Tổng: 200000VND',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.deepOrange),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  void _showBottomModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Star ratings widget (you can use your own star rating widget)
              // Replace the following line with your actual star rating widget
              const Text('Tên sản phẩm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Chất lượng sản phẩm:'),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  RatingBar.builder(
                    itemSize: 32,
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
                  onPressed: () {
                    // Add logic to submit the review
                    addReview();
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
}
