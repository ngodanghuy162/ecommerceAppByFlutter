import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_variant_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/styles/product_price_text.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({
    super.key,
    required this.variant,
    required this.product,
    required this.maxPrice,
    required this.minPrice,
    required this.discount,
  });

  final ProductVariantModel variant;
  final ProductModel product;
  final double maxPrice;
  final double minPrice;
  final int discount;


  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final variantsController = Get.put(ProductVariantController());

  late double maxPrice;
  late double minPrice;
  late int discount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    maxPrice = widget.maxPrice;
    minPrice = widget.minPrice;
    discount = widget.discount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(title: Text("Chatting with shop", style: TextStyle(color: TColors.white),), showBackArrow: true, backgroundColor: Colors.blue),
      body: Column(
        children: [
          TRoundedContainer(
            showBorder: true,
            borderColor: TColors.darkGrey,
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(12),
            child: Column(
              children: [
                const Text('Bạn đang trao đổi với Người bán về sản phẩm này'),
                const Divider(height: 8),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image(
                        image: NetworkImage(widget.variant.imageURL),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.product.name),
                          Text(
                            minPrice == maxPrice
                                ? '$minPrice'
                                : "\$$minPrice - $maxPrice",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .apply(decoration: TextDecoration.lineThrough),
                          ),
                          const SizedBox(
                            width: TSizes.spaceBtwItems,
                          ),
                          TProductPriceText(
                            price: minPrice == maxPrice
                                ? priceAfterDis(minPrice, discount)
                                : " ${priceAfterDis(minPrice, discount)} - ${priceAfterDis(maxPrice, discount)}",
                            isLarge: false,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Text('Hello'),
        ],
      ),
    );
  }
}

String priceAfterDis(double price, int discount) {
  double res = price * ((100 - discount) / 100);
  return res.toStringAsFixed(1);
}
