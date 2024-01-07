import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/cart_controller/cart_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

// ignore: must_be_immutable
class TProductInCart extends StatefulWidget {
  TProductInCart(
      {super.key,
      this.currencySign = '\$',
      required this.price,
      this.isShowQuantity = false,
      this.maxLines = 1,
      this.quantity,
      this.isLarge = false,
      required this.indexInCart,
      this.productModel,
      this.productVariantId,
      required this.indexInShop,
      this.lineThrough = false});

  final String currencySign, price;
  final int maxLines;
  final bool isLarge, lineThrough;
  final bool isShowQuantity;
  final int indexInCart;
  int? quantity;
  final int indexInShop;
  String? productVariantId;
  ProductModel? productModel;

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
                    onPressed: () async {
                      setState(() {
                        if (widget.quantity == 1) {
                          UserRepository.instance.deleteProductFromCart(
                              widget.productVariantId!, widget.productModel!);
                          // CartController.instance
                          //     .listNumberProductInOneShop[widget.indexInCart]--;
                          //tru di 1
                          CartController
                              .instance
                              .listSizeProductInShop[widget.indexInCart]
                              .value--;
                          CartController
                              .instance.listProduct[widget.indexInCart]
                              .remove(widget.productModel);
                          CartController
                              .instance.listVariant[widget.indexInCart]
                              .removeAt(widget.indexInShop);
                          CartController
                              .instance.listQuantity[widget.indexInCart]
                              .removeAt(widget.indexInShop);
                          // CartController.instance
                          // .listSizeProductInShop[widget.indexInCart].value--;
                          // CartController.instance.listSizeProductInShop
                          //     .removeAt(widget.indexInCart);
                          //neu shop co 1 san pham thi
                          if (CartController
                                  .instance
                                  .listSizeProductInShop[widget.indexInCart]
                                  .value ==
                              0) {
                            CartController.instance.listSizeProductInShop
                                .removeAt(widget.indexInCart);
                            CartController.instance.numberOfShop.value--;

                            CartController.instance.listShop
                                .removeAt(widget.indexInCart);
                          }
                          return;
                        }
                        widget.quantity = (widget.quantity! - 1);
                        CartController.instance.listQuantity[widget.indexInCart]
                            [widget.indexInShop]--;
                        //update lístprice
                        // CartController.instance.listPrice[widget.indexInCart]
                        //         [widget.indexInShop] =
                        //     (widget.quantity! * double.tryParse(widget.price)!);
                        //update lai total amout de hien thi
                        CartController.instance.updateTotalAmount(
                            widget.indexInCart, widget.indexInShop, false);
                        //update quantity len database
                        UserRepository.instance.updateQuantityInCart(
                            widget.quantity!,
                            CartController
                                .instance
                                .listVariant[widget.indexInCart]
                                    [widget.indexInShop]
                                .id!,
                            CartController
                                    .instance.listProduct[widget.indexInCart]
                                [widget.indexInShop]);
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
                        //cap nhat so luong ++
                        CartController.instance.listQuantity[widget.indexInCart]
                            [widget.indexInShop]++;
                        //cap nhat gia
                        // CartController.instance.listPrice[widget.indexInCart]
                        //         [widget.indexInShop!] =
                        //     (widget.quantity! * double.tryParse(widget.price)!);
                        //update lai total amout
                        CartController.instance.updateTotalAmount(
                            widget.indexInCart, widget.indexInShop, true);
                        //update quantrity len dataanase
                        UserRepository.instance.updateQuantityInCart(
                            widget.quantity!,
                            CartController
                                .instance
                                .listVariant[widget.indexInCart]
                                    [widget.indexInShop]
                                .id!,
                            CartController
                                    .instance.listProduct[widget.indexInCart]
                                [widget.indexInShop]);
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
