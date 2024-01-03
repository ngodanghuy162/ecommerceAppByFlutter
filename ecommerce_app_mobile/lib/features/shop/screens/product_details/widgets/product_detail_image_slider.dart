import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:ecommerce_app_mobile/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_app_mobile/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TProductImageSlider extends StatefulWidget {
  TProductImageSlider(
      {super.key, required this.listVariant, this.productModel});

  final List<ProductVariantModel> listVariant;

  ProductModel? productModel;

  @override
  State<TProductImageSlider> createState() => _TProductImageSliderState();
}

class _TProductImageSliderState extends State<TProductImageSlider> {
  RxBool isInWishlist = false.obs;

  int indexVariant = 0;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    ProductVariantModel variant = widget.listVariant[indexVariant];

    return FutureBuilder<Object>(
        future:
            UserRepository.instance.isProductInWishList(widget.productModel!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            isInWishlist.value = snapshot.data as bool;
            return TCurvedEdgeWidget(
              child: Container(
                color: dark ? TColors.darkerGrey : TColors.light,
                child: Stack(
                  children: [
                    /// Main Large Image
                    SizedBox(
                        height: 400,
                        child: Padding(
                          padding: const EdgeInsets.all(
                              TSizes.productImageRadius * 2),
                          child: Center(child: Image.network(variant.imageURL)),
                        )),

                    /// Image Slider
                    Positioned(
                      right: 0,
                      bottom: 30,
                      left: TSizes.defaultSpace,
                      child: SizedBox(
                        height: 80,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const AlwaysScrollableScrollPhysics(),
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: TSizes.spaceBtwItems),
                          itemCount: widget.listVariant.length,
                          itemBuilder: (_, index) => TRoundedImage(
                            width: 80,
                            backgroundColor:
                                dark ? TColors.dark : TColors.white,
                            border: indexVariant == index
                                ? Border.all(color: TColors.primary)
                                : null,
                            padding: const EdgeInsets.all(TSizes.sm),
                            imageUrl: widget.listVariant[index].imageURL,
                            isNetworkImage: true,
                            onPressed: () {
                              setState(() {
                                indexVariant = index;
                              });
                            },
                          ),
                        ),
                      ),
                    ),

                    /// Appbar Icons
                    TAppBar(
                      showBackArrow: true,
                      actions: [
                        Obx(
                          () => TCircularIcon(
                            icon: isInWishlist.value
                                ? Iconsax.heart5
                                : Iconsax.heart_add,
                            color: Colors.red,
                            onPressed: () async {
                              await UserRepository.instance
                                  .addOrRemoveProductToWishlist(
                                      widget.productModel!);
                              isInWishlist.value = !isInWishlist.value;
                              ;
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return const CircularCappedProgressIndicator();
          }
        });
  }
}
