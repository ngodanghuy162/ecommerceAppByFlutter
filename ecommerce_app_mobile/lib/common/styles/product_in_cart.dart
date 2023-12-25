import 'package:ecommerce_app_mobile/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/cart_controller/cart_controller.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TProductInCart extends StatefulWidget {
  TProductInCart(
      {super.key,
      this.currencySign = '\$',
      required this.price,
      this.isShowQuantity = false,
      this.maxLines = 1,
      this.quantity,
      this.isLarge = false,
      this.index,
      this.lineThrough = false});

  final String currencySign, price;
  final int maxLines;
  final bool isLarge, lineThrough;
  final bool isShowQuantity;
  int? quantity;
  int? index;

  @override
  State<TProductInCart> createState() => _TProductPriceTextState();
}

class _TProductPriceTextState extends State<TProductInCart> {
  @override
  Widget build(BuildContext context) {
    Get.put(CartController());
    return Column(
      children: [
        widget.isShowQuantity
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TCircularIcon(
                    icon: Iconsax.minus,
                    width: 32,
                    height: 32,
                    size: TSizes.md,
                    color: THelperFunctions.isDarkMode(context)
                        ? TColors.white
                        : TColors.black,
                    backgroundColor: THelperFunctions.isDarkMode(context)
                        ? TColors.darkerGrey
                        : TColors.light,
                    onPressed: () {
                      setState(() {
                        widget.quantity = (widget.quantity! - 1);
                        CartController.instance.eachPriceInCart[widget.index!] =
                            (widget.quantity! * double.tryParse(widget.price)!);
                        CartController.instance.updateTotalAmount();
                      });
                    },
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Text(widget.quantity.toString()),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  TCircularIcon(
                    icon: Iconsax.add,
                    width: 32,
                    height: 32,
                    size: TSizes.md,
                    color: TColors.white,
                    backgroundColor: TColors.primary,
                    onPressed: () {
                      setState(() {
                        widget.quantity = (widget.quantity! + 1);
                        CartController.instance.eachPriceInCart[widget.index!] =
                            (widget.quantity! * double.tryParse(widget.price)!);
                        CartController.instance.updateTotalAmount();
                      });
                    },
                  ),
                ],
              )
            : const SizedBox(
                width: 0.1,
                height: 0.1,
              ),
        Text(
          widget.currencySign +
              (double.tryParse(widget.price)! * widget.quantity!).toString(),
          maxLines: widget.maxLines,
          overflow: TextOverflow.ellipsis,
          style: widget.isLarge
              ? Theme.of(context).textTheme.headlineMedium!.apply(
                  decoration:
                      widget.lineThrough ? TextDecoration.lineThrough : null)
              : Theme.of(context).textTheme.titleLarge!.apply(
                  decoration:
                      widget.lineThrough ? TextDecoration.lineThrough : null),
        ),
      ],
    );
  }
}
