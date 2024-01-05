import 'package:ecommerce_app_mobile/common/styles/product_title_text.dart';
import 'package:ecommerce_app_mobile/common/styles/t_brand_title_text_with_verified_icon.dart';
import 'package:ecommerce_app_mobile/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/cart_controller/cart_controller.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TCartItemByHuy extends StatefulWidget {
  final String? brand;
  final String? imgUrl;
  final String? title;
  final Color? color;
  final String? size;
  final int indexInShop;
  final int indexinCart;
  final ValueChanged<bool> onCheckboxChanged;
  bool? checkboxValue;
  TCartItemByHuy({
    this.brand,
    this.title,
    this.imgUrl,
    this.color,
    this.size,
    required this.onCheckboxChanged,
    this.checkboxValue,
    required this.indexInShop,
    required this.indexinCart,
    super.key,
  });

  @override
  State<TCartItemByHuy> createState() => _TCartItemByHuyState();
}

class _TCartItemByHuyState extends State<TCartItemByHuy> {
  @override
  Widget build(BuildContext context) {
    Get.put(CartController());
    return Row(
      children: [
        // Checkbox
        Checkbox(
          value: widget.checkboxValue,
          onChanged: (newValue) {
            setState(() {
              widget.checkboxValue = newValue!;
              if (widget.checkboxValue!) {
                print('Đã tích product');
                CartController.instance.addChoosenListByIndexProduct(
                    widget.indexinCart, widget.indexInShop);
              } else {
                CartController.instance.deleteChoosenListByIndexProduct(
                    widget.indexinCart, widget.indexInShop);
                print('Chưa tích product');
              }
              widget.onCheckboxChanged(widget.checkboxValue!);
            });
          },
        ),
        //Image
        TRoundedImage(
          imageUrl: widget.imgUrl ?? TImages.productImage1,
          width: 60,
          height: 60,
          isNetworkImage: true,
          padding: const EdgeInsets.all(TSizes.sm),
          backgroundColor: THelperFunctions.isDarkMode(context)
              ? TColors.darkerGrey
              : TColors.light,
        ),
        const SizedBox(width: TSizes.spaceBtwItems),

        //Title, price, sizes
        //Branch title with verified
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TBrandTitleWithVerifiedIcon(title: widget.brand ?? ""),
              Flexible(
                child: TProductTitleText(
                  title: widget.title!,
                  maxLines: 1,
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Color ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    // TextSpan(
                    //   text: "Green",
                    //   style: Theme.of(context).textTheme.bodyLarge,
                    // ),
                    WidgetSpan(
                      child: Container(
                        width: 16, // Kích thước của hình tròn
                        height: 16,
                        margin: const EdgeInsets.only(
                            bottom: 2,
                            right: 5), // Khoảng cách giữa văn bản và hình tròn
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.color ??
                              Colors
                                  .lightBlue, // Màu của hình tròn, mặc định là màu xanh lá cây
                        ),
                      ),
                    ),
                    TextSpan(
                      text: 'Sizes ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: widget.size ?? "42US",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
