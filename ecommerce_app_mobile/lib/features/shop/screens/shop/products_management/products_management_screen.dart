import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/product_history/product_order_history_bar_item.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/shop_controller/shop_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/address/address.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/chat/shop_reply_chatting_screen.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/sell_product/sell_product.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/shop/order_management/shop_product_history_order_screen.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/shop/products_management/widgets/sortable_product.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/statistics/statistics_screen.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProductsManagementScreen extends StatelessWidget {
  const ProductsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color color = TColors.darkerGrey;
    return Scaffold(
      backgroundColor: TColors.primaryBackground,
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text("My shop products"),
      ),
      body: ShopSortableProducts(),
    );
  }
}

class ListTitleCustom extends StatelessWidget {
  const ListTitleCustom({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subTitle;
  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: TColors.primary,
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: TColors.light,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: TColors.light,
          ),
        ),
        subtitle: Text(
          subTitle,
          style: const TextStyle(
            color: TColors.light,
          ),
        ),
        trailing: const Icon(
          Iconsax.arrow_right_34,
          color: TColors.light,
        ),
      ),
    );
  }
}
