import 'package:ecommerce_app_mobile/common/styles/section_heading.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/brand_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_details/widgets/bottom_add_to_cart_widget.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_details/widgets/product_attributes.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_details/widgets/rating_share_widget.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_reviews/product_reviews.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductDetailScreen(
      {super.key,
      required this.product,
      this.brand,
      required this.listVariants});
  final ProductModel product;
  final BrandModel? brand;
  final List<ProductVariantModel> listVariants;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final brandController = Get.put(BrandController());
  late int indexCurrentVariant;

  @override
  Widget build(BuildContext context) {
    //final dark = THelperFunctions.isDarkMode(context);

    var minPrice = double.infinity, maxPrice = 0.0;
    for (var e in widget.listVariants) {
      minPrice = e.price < minPrice ? e.price : minPrice;
      maxPrice = e.price > maxPrice ? e.price : maxPrice;
    }
    indexCurrentVariant = 0;
    return Scaffold(
      bottomNavigationBar: const TBottomAddToCart(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Product Image Slider
            const TProductImageSlider(),

            /// Product Details
            Padding(
              padding: const EdgeInsets.only(
                  right: TSizes.defaultSpace,
                  left: TSizes.defaultSpace,
                  bottom: TSizes.defaultSpace),
              child: Column(
                children: [
                  /// Rating & Share Button
                  const TRatingAndShare(),

                  /// Price, Title, Stack & Brand
                  TProductMetaData(
                    product: widget.product,
                    nameBrand: widget.brand!.name,
                    maxPrice: maxPrice,
                    minPrice: minPrice,
                  ),

                  /// Attributes
                  TProductAttributes(
                    index: indexCurrentVariant,
                    listVariants: widget.listVariants,
                    product: widget.product,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  /// Checkout Button
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {}, child: const Text('Checkout'))),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  /// Description
                  const TSectionHeading(
                    title: 'Description',
                    showActionButton: false,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  ReadMoreText(
                    widget.product.description,
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' Show more',
                    trimExpandedText: ' Less',
                    moreStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                  ),

                  /// Reviews
                  const Divider(),
                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TSectionHeading(
                        title: 'Reviews(199)',
                        showActionButton: false,
                      ),
                      IconButton(
                        icon: const Icon(
                          Iconsax.arrow_right_3,
                          size: 18,
                        ),
                        onPressed: () =>
                            Get.to(() => const ProductReviewsScreen()),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
