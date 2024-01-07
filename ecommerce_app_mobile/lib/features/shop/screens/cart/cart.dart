import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/cart/list_shop.dart';
import 'package:ecommerce_app_mobile/features/personalization/screens/address/address.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/cart_controller/cart_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/cart/cart_items_widget/cart_items.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/checkout/checkout_screen.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final userController = Get.put(UserRepository());

  @override
  Widget build(BuildContext context) {
    final currentUserModel = userController.currentUserModel;
    Get.put(CartController());
    return Scaffold(
        appBar: TAppBar(
          title: Text(
            'Cart',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          showBackArrow: true,
        ),
        body: const ListShop(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: ElevatedButton(
            onPressed: () {
              if (currentUserModel!.address!.isEmpty) {
                SmartDialog.showToast('Please add address to continue',
                    alignment: Alignment.center);
                Get.to(() => const UserAddressScreen());
              } else {
                Get.to(
                  () => CheckoutScreen(
                    shopAndProductVariantQuantity:
                        CartController.instance.chooSenShopAndProduct,
                  ),
                );
              }
            },
            child: Obx(
              () => Text(
                  'Checkout \$${CartController.instance.totalAmount.value}'),
            ),
          ),
        ));
  }
}
