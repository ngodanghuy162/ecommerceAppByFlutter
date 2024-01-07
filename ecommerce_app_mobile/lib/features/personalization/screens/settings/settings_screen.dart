import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/authentication_repository.dart';
import 'package:ecommerce_app_mobile/Service/repository/order_respository/order_respository.dart';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/common/dialog/dialog.dart';
import 'package:ecommerce_app_mobile/common/styles/section_heading.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/primary_header_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/list_tiles/settings_menu_tile.dart';
import 'package:ecommerce_app_mobile/common/widgets/list_tiles/user_profile_tile.dart';
import 'package:ecommerce_app_mobile/common/widgets/loading/custom_loading.dart';
import 'package:ecommerce_app_mobile/features/personalization/controllers/settings_controller.dart';
import 'package:ecommerce_app_mobile/features/personalization/screens/address/address.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/cart/cart.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/coupons/voucher_screen.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/product_history_order/product_history_order.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/shop/create_shop_screen.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/shop/shop_screen.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/product_history/product_order_history_bar.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final settingsController = Get.put(SettingsController());
  final orderRepository = Get.put(OrderRepository());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            TPrimaryHeaderContainer(
                child: Column(
              children: [
                /// Appbar
                TAppBar(
                    showBackArrow: false,
                    title: Text('Account',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .apply(color: TColors.white))),

                // User Profile Card
                //Profile picture
                FutureBuilder(
                  future: settingsController.getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        UserModel userModel = snapshot.data as UserModel;
                        return SizedBox(
                          height: 65,
                          child: TUserProfileTitle(
                            profileUrl: userModel.avatar_imgURL!,
                            email: userModel.email,
                            firstName: userModel.firstName,
                            lastName: userModel.lastName,
                          ),
                        );
                      }
                    }
                    return const SizedBox(
                      height: 65,
                      child: Center(
                        child: Center(child: CustomLoading()),
                      ),
                    );
                  },
                ),

                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            )),

            /// Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  const TSectionHeading(
                    title: "Order History",
                    showActionButton: false,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  Obx(
                    () => ProductOrderHistoryBar(
                      completed:
                          orderRepository.getOrderHistoryBarInfo()['completed'],
                      delivering: orderRepository
                          .getOrderHistoryBarInfo()['delivering'],
                      confirmation: orderRepository
                          .getOrderHistoryBarInfo()['confirmation'],
                      cancelled:
                          orderRepository.getOrderHistoryBarInfo()['cancelled'],
                    ),
                  ),

                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),

                  /// Account Setting
                  const TSectionHeading(
                    title: "Account Settings",
                    showActionButton: false,
                  ),
                  FutureBuilder<bool>(
                      future: UserRepository.instance.isSeller(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            bool isSeller = snapshot.data!;
                            return isSeller
                                ? TSettingsMenuTile(
                                    icon: Iconsax.shop,
                                    title: "My Shop",
                                    subTitle: "Get to my shop",
                                    onTap: () =>
                                        Get.to(() => const MyShopScreen()),
                                  )
                                : TSettingsMenuTile(
                                    icon: Iconsax.shop,
                                    title: "Register Shop",
                                    subTitle: "Register to be Seller",
                                    onTap: () {
                                      showDialogOnScreen(
                                        context: context,
                                        title: "Are you sure?",
                                        description:
                                            "Are you sure to be a seller??",
                                        onOkPressed: () => Get.to(
                                            () => const CreateShopScreen()),
                                      );
                                    },
                                  );
                          }
                        }
                        return Container();
                      }),
                  TSettingsMenuTile(
                    icon: Iconsax.safe_home,
                    title: 'My Addresses',
                    subTitle: 'Set shopping delivery address',
                    onTap: () => Get.to(const UserAddressScreen()),
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.shopping_cart,
                    title: 'My Cart',
                    subTitle: 'Add, remove products and move to checkout',
                    onTap: () => Get.to(() => CartScreen()),
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.bag_tick,
                    title: 'My Orders',
                    subTitle: 'In-progress and Completed Orders',
                    onTap: () => Get.to(
                        () => const ProductHistoryOrder(initialIndex: 0)),
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.discount_shape,
                    title: 'My Vouchers',
                    subTitle: 'List of all the discounted coupons',
                    onTap: () => Get.to(() => const VoucherScreen()),
                  ),
                  // const TSettingsMenuTile(
                  //   icon: Iconsax.notification,
                  //   title: 'Notifications',
                  //   subTitle: 'Set any kind of notification message',
                  // ),
                  // const TSettingsMenuTile(
                  //   icon: Iconsax.security_card,
                  //   title: 'Account Privacy',
                  //   subTitle: 'Manage data usage and connected accounts',
                  // ),

                  /// App Settings
                  // const SizedBox(
                  //   height: TSizes.spaceBtwSections,
                  // ),
                  // const TSectionHeading(
                  //   title: 'App Settings',
                  //   showActionButton: false,
                  // ),
                  // const SizedBox(
                  //   height: TSizes.spaceBtwItems,
                  // ),
                  // const TSettingsMenuTile(
                  //     icon: Iconsax.document_upload,
                  //     title: 'Load Data',
                  //     subTitle: 'Upload Data to your Cloud Firebase'),
                  // TSettingsMenuTile(
                  //   icon: Iconsax.location,
                  //   title: 'Geolocation',
                  //   subTitle: 'Set recommendation based on location',
                  //   trailing: Switch(value: true, onChanged: (value) {}),
                  // ),
                  // TSettingsMenuTile(
                  //   icon: Iconsax.security_user,
                  //   title: 'Safe Mode',
                  //   subTitle: 'Search result is safe for all ages',
                  //   trailing: Switch(value: false, onChanged: (value) {}),
                  // ),
                  // TSettingsMenuTile(
                  //   icon: Iconsax.image,
                  //   title: 'HD Image Quality',
                  //   subTitle: 'Set image quality to be seen',
                  //   trailing: Switch(value: false, onChanged: (value) {}),
                  // ),

                  /// Logout Button
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        await showDialogOnScreen(
                          context: context,
                          title: "Log out here",
                          description: "Are you sure to log out??",
                          onOkPressed: () async {
                            await AuthenticationRepository.instance.logout();
                            Get.snackbar("Logout successfully",
                                "Please log in again to continue.");
                          },
                        );
                      },
                      child: const Text('Logout'),
                    ),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections * 2.5,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
