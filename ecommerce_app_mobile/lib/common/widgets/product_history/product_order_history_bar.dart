import 'package:ecommerce_app_mobile/features/shop/screens/product_history_order/product_history_order.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'product_order_history_bar_item.dart';

class ProductOrderHistoryBar extends StatelessWidget {
  const ProductOrderHistoryBar({
    super.key,
    required this.confirmation,
    required this.delivering,
    required this.completed,
    required this.cancelled,
  });

  final int confirmation, delivering, completed, cancelled;

  @override
  Widget build(BuildContext context) {
    Color color = TColors.darkerGrey;
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () =>
                Get.to(() => const ProductHistoryOrder(initialIndex: 0)),
            child: ProductOrderHistoryBarItem(
              color: color,
              icon: Iconsax.card_tick_1,
              label: 'Confirmation',
              badgeLabel: confirmation,
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () =>
                Get.to(() => const ProductHistoryOrder(initialIndex: 1)),
            child: ProductOrderHistoryBarItem(
              color: color,
              icon: Iconsax.truck_fast,
              label: 'Delivering',
              badgeLabel: delivering,
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () =>
                Get.to(() => const ProductHistoryOrder(initialIndex: 2)),
            child: ProductOrderHistoryBarItem(
              color: color,
              icon: Iconsax.truck_tick,
              label: 'Completed',
              badgeLabel: completed,
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () =>
                Get.to(() => const ProductHistoryOrder(initialIndex: 3)),
            child: ProductOrderHistoryBarItem(
              color: color,
              icon: Iconsax.truck_remove,
              label: 'Cancelled',
              badgeLabel: cancelled,
            ),
          ),
        ),
      ],
    );
  }
}
