import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/shop_controller/shop_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/shop/order_management/widgets/shop_product_history_card.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopProductHistoryOrder extends StatefulWidget {
  const ShopProductHistoryOrder({super.key, required this.initialIndex});

  final int initialIndex;

  @override
  State<ShopProductHistoryOrder> createState() =>
      _ShopProductHistoryOrderState();
}

class _ShopProductHistoryOrderState extends State<ShopProductHistoryOrder> {
  final shopController = Get.put(ShopController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title:
            Text("Shop Order History", style: TextStyle(color: Colors.black)),
      ),
      body: Obx(
        () => ContainedTabBarView(
          tabBarProperties: TabBarProperties(
            labelColor: TColors.primary,
            indicatorColor: TColors.primary,
            height: MediaQuery.of(context).size.height * 0.06,
            labelStyle: const TextStyle(
              color: Colors.black,
            ),
          ),
          initialIndex: widget.initialIndex,
          tabs: const [
            Text("Confirmation",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text("Delivering",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text("Completed",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text("Cancelled",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
          views: [
            Padding(
              padding: const EdgeInsets.all(TSizes.spaceBtwItems),
              child: RefreshIndicator(
                onRefresh: () async {
                  await shopController.updateShopOrderList();
                },
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: shopController.shopOrderList
                      .where((p0) => p0['status'] == 'confirmation')
                      .toList()
                      .length,
                  itemBuilder: (context, index) {
                    return ShopProductOrderCard(
                      shopAndProducts: shopController.shopOrderList
                          .where((p0) => p0['status'] == 'confirmation')
                          .toList()[index],
                    );
                  },
                  separatorBuilder: (ctx, index) =>
                      const SizedBox(height: TSizes.sm),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.spaceBtwItems),
              child: RefreshIndicator(
                onRefresh: () async {
                  await shopController.updateShopOrderList();
                },
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: shopController.shopOrderList
                      .where((p0) => p0['status'] == 'delivering')
                      .toList()
                      .length,
                  itemBuilder: (context, index) {
                    return ShopProductOrderCard(
                      shopAndProducts: shopController.shopOrderList
                          .where((p0) => p0['status'] == 'delivering')
                          .toList()[index],
                    );
                  },
                  separatorBuilder: (ctx, index) =>
                      const SizedBox(height: TSizes.sm),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.spaceBtwItems),
              child: RefreshIndicator(
                onRefresh: () async {
                  await shopController.updateShopOrderList();
                },
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: shopController.shopOrderList
                      .where((p0) => p0['status'] == 'completed')
                      .toList()
                      .length,
                  itemBuilder: (context, index) {
                    return ShopProductOrderCard(
                      shopAndProducts: shopController.shopOrderList
                          .where((p0) => p0['status'] == 'completed')
                          .toList()[index],
                    );
                  },
                  separatorBuilder: (ctx, index) =>
                      const SizedBox(height: TSizes.sm),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.spaceBtwItems),
              child: RefreshIndicator(
                onRefresh: () async {
                  await shopController.updateShopOrderList();
                },
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: shopController.shopOrderList
                      .where((p0) => p0['status'] == 'cancelled')
                      .toList()
                      .length,
                  itemBuilder: (context, index) {
                    return ShopProductOrderCard(
                      shopAndProducts: shopController.shopOrderList
                          .where((p0) => p0['status'] == 'cancelled')
                          .toList()[index],
                    );
                  },
                  separatorBuilder: (ctx, index) =>
                      const SizedBox(height: TSizes.sm),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
