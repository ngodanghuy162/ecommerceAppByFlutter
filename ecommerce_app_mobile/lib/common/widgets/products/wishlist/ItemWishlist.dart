import 'package:ecommerce_app_mobile/features/shop/controllers/wishlist/wishlist_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_details/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/common/styles/product_title_text.dart';
import 'package:ecommerce_app_mobile/common/styles/t_brand_title_text_with_verified_icon.dart';
import 'package:ecommerce_app_mobile/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

class TWishListItem extends StatelessWidget {
  TWishListItem({
    required this.product,
    required this.brand,
    required this.listVariants,
    this.isNetWorkImg,
    super.key,
  });

  final ProductModel product;
  final BrandModel brand;
  final List<ProductVariantModel> listVariants;
  bool? isNetWorkImg = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetailScreen(
            product: product, brand: brand, listVariants: listVariants));
      },
      child: Row(
        children: [
          // Image
          TRoundedImage(
            imageUrl: listVariants[0].imageURL ?? TImages.productImage1,
            width: 60,
            height: 60,
            isNetworkImage: true,
            padding: const EdgeInsets.all(TSizes.sm),
            backgroundColor: THelperFunctions.isDarkMode(context)
                ? TColors.darkerGrey
                : TColors.light,
          ),
          const SizedBox(width: TSizes.spaceBtwItems),

          // Title, price, sizes
          // Branch title with verified
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TBrandTitleWithVerifiedIcon(
                  title: brand.name,
                  isVerified: brand.isVerified,
                ),
                Flexible(
                  child: TProductTitleText(
                    title: product.name,
                    maxLines: 1,
                  ),
                ),
                // IconButton(
                //   onPressed: () {
                //     UserRepository.instance
                //         .addOrRemoveProductToWishlist(product);
                //     WishlistController.instance.listProductSize.value--;
                //   },
                //   icon: const Icon(Icons.delete),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
