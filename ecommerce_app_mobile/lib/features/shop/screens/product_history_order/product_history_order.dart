import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:ecommerce_app_mobile/Service/Model/product_review_model/product_review_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/order_respository/order_respository.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_review_controller/product_review_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_history_order/widgets/dropdown_products_review.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_history_order/widgets/product_history_card.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../../../../Service/repository/authentication_repository.dart';

class ProductHistoryOrder extends StatefulWidget {
  const ProductHistoryOrder({super.key, required this.initialIndex});

  final int initialIndex;

  @override
  State<ProductHistoryOrder> createState() => _ProductHistoryOrderState();
}

class _ProductHistoryOrderState extends State<ProductHistoryOrder> {
  TextEditingController commentController = TextEditingController();
  final reviewController = Get.put(ProductReviewController());
  final _authRepo = Get.put(AuthenticationRepository());
  final _orderRepo = Get.put(OrderRepository());

  late double finalRating;

  Future<void> addReview(String productId) async {
    String content = commentController.text;
    String? userEmail = _authRepo.firebaseUser.value?.email;
    if (content.isNotEmpty) {
      ProductReviewModel newReview = ProductReviewModel(
        rating: finalRating,
        userEmail: userEmail as String,
        content: content,
        date: Timestamp.fromDate(DateTime.now()),
      );
      await reviewController.createReview(newReview, productId);
      finalRating = 5.0;
      content = '';
      Get.back();
      // Get.to(() => ProductReviewsScreen()); //! điều hướng sau
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text("Order History", style: TextStyle(color: Colors.black)),
      ),
      body: ContainedTabBarView(
        tabBarProperties: TabBarProperties(
          labelColor: TColors.primary,
          indicatorColor: TColors.primary,
          height: MediaQuery.of(context).size.height * 0.06,
          labelStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
        initialIndex: widget.initialIndex,
        tabs: const [
          Text("Confirmation",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text("Delivering",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text("Completed",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text("Cancelled",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
        views: [
          Padding(
            padding: const EdgeInsets.all(TSizes.spaceBtwItems),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _orderRepo.userOrderList
                  .where((p0) => p0['status'] == 'confirmation')
                  .toList()
                  .length,
              itemBuilder: (context, index) {
                return ProductOrderCard(
                  shopAndProducts: _orderRepo.userOrderList
                      .where((p0) => p0['status'] == 'confirmation')
                      .toList()[index],
                );
              },
              separatorBuilder: (ctx, index) =>
                  const SizedBox(height: TSizes.sm),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(TSizes.spaceBtwItems),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _orderRepo.userOrderList
                  .where((p0) => p0['status'] == 'delivering')
                  .toList()
                  .length,
              itemBuilder: (context, index) {
                return ProductOrderCard(
                  shopAndProducts: _orderRepo.userOrderList
                      .where((p0) => p0['status'] == 'delivering')
                      .toList()[index],
                );
              },
              separatorBuilder: (ctx, index) =>
                  const SizedBox(height: TSizes.sm),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(TSizes.spaceBtwItems),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _orderRepo.userOrderList
                  .where((p0) => p0['status'] == 'completed')
                  .toList()
                  .length,
              itemBuilder: (context, index) {
                return ProductOrderCard(
                  shopAndProducts: _orderRepo.userOrderList
                      .where((p0) => p0['status'] == 'completed')
                      .toList()[index],
                  showReviewModal: showBottomModal,
                );
              },
              separatorBuilder: (ctx, index) =>
                  const SizedBox(height: TSizes.sm),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(TSizes.spaceBtwItems),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _orderRepo.userOrderList
                  .where((p0) => p0['status'] == 'cancelled')
                  .toList()
                  .length,
              itemBuilder: (context, index) {
                return ProductOrderCard(
                  shopAndProducts: _orderRepo.userOrderList
                      .where((p0) => p0['status'] == 'cancelled')
                      .toList()[index],
                );
              },
              separatorBuilder: (ctx, index) =>
                  const SizedBox(height: TSizes.sm),
            ),
          ),
        ],
      ),
    );
  }

  void showBottomModal(
      BuildContext context, List<Map<String, String>> products) {
    String productId = products.first['key']!;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Star ratings widget (you can use your own star rating widget)
              // Replace the following line with your actual star rating widget
              const Text(
                'ProductName',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
              DropdownProductsReview(
                initialValue: productId,
                options: products,
                onChanged: (value) {
                  productId = value;
                },
              ),
              const SizedBox(
                height: TSizes.defaultSpace,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Rating:'),
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
                  hintText: 'Type your comment...',
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
                    'Back',
                    style: TextStyle(color: TColors.black),
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwSections),
                ElevatedButton(
                  onPressed: () async {
                    // Add logic to submit the review
                    await addReview(productId);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ), // Đặt độ cong cho viền của nút
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 24.0), // Đặt khoảng cách giữa chữ và viền
                  ),
                  child: const Text(
                    'Confirm',
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
