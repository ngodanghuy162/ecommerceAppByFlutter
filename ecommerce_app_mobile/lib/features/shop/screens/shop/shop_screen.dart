import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/product_history/product_order_history_bar_item.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/shop_controller/shop_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/address/address.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/chat/shop_reply_chatting_screen.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/coupons/shop/shop_create_voucher.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/sell_product/sell_product.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/shop/order_management/shop_product_history_order_screen.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/shop/products_management/products_management_screen.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/statistics/statistics_screen.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class MyShopScreen extends StatelessWidget {
  const MyShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShopController());
    Color color = TColors.darkerGrey;
    return Scaffold(
      backgroundColor: TColors.primaryBackground,
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text("Here is your shop"),
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [],
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(TSizes.spaceBtwItems),
          child: ListView(
            shrinkWrap: true,
            children: [
              Obx(
                () => GridView.count(
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.only(bottom: TSizes.defaultSpace),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 4,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    InkWell(
                      borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                      onTap: () => Get.to(
                          () => const ShopProductHistoryOrder(initialIndex: 0)),
                      child: TRoundedContainer(
                        child: Center(
                          child: ProductOrderHistoryBarItem(
                            color: color,
                            icon: Iconsax.card_tick_1,
                            label: 'Confirmation',
                            badgeLabel: controller
                                .getOrderHistoryBarInfo()['confirmation'],
                            size: double.infinity,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                      onTap: () => Get.to(
                          () => const ShopProductHistoryOrder(initialIndex: 1)),
                      child: TRoundedContainer(
                        child: Center(
                          child: ProductOrderHistoryBarItem(
                            color: color,
                            icon: Iconsax.truck_fast,
                            label: 'Delivering',
                            badgeLabel: controller
                                .getOrderHistoryBarInfo()['delivering'],
                            size: double.infinity,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                      onTap: () => Get.to(
                          () => const ShopProductHistoryOrder(initialIndex: 2)),
                      child: TRoundedContainer(
                        child: Center(
                          child: ProductOrderHistoryBarItem(
                            color: color,
                            icon: Iconsax.truck_tick,
                            label: 'Completed',
                            badgeLabel: controller
                                .getOrderHistoryBarInfo()['completed'],
                            size: double.infinity,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                      onTap: () => Get.to(
                          () => const ShopProductHistoryOrder(initialIndex: 3)),
                      child: TRoundedContainer(
                        child: Center(
                          child: ProductOrderHistoryBarItem(
                            color: color,
                            icon: Iconsax.truck_remove,
                            label: 'Cancelled',
                            badgeLabel: controller
                                .getOrderHistoryBarInfo()['cancelled'],
                            size: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTitleCustom(
                title: 'Add product',
                subTitle: 'Add product to sell',
                icon: Iconsax.add,
                onTap: () => Get.to(() => const SellProductScreen()),
              ),
              ListTitleCustom(
                title: 'Reply chatting',
                subTitle: 'Chat with customers',
                icon: Iconsax.message,
                onTap: () => Get.to(() => const ShopReplyChattingScreen()),
              ),
              ListTitleCustom(
                title: 'Address',
                subTitle: 'Add shop address',
                icon: Iconsax.location,
                onTap: () => Get.to(() => const ShopAddressScreen()),
              ),
              ListTitleCustom(
                title: 'My products',
                subTitle: 'Management products',
                icon: Iconsax.shopping_bag,
                onTap: () => Get.to(() => const ProductsManagementScreen()),
              ),
              ListTitleCustom(
                title: 'Statistics',
                subTitle: 'See chart',
                icon: Iconsax.chart,
                onTap: () => Get.to(() => const StatisticScreen()),
              ),
              ListTitleCustom(
                title: 'Create Voucher',
                subTitle: 'Create your shop voucher',
                icon: Iconsax.ticket_discount,
                onTap: () => Get.to(() => const ShopCreateVoucher()),
              ),
            ],
          )),
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
