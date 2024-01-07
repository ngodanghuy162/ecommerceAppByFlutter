import 'package:ecommerce_app_mobile/features/personalization/screens/settings/settings_screen.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/home/home.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/store/store.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/wishlist/wishlist_screen.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key, this.initialIndex});

  final int? initialIndex;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: darkMode ? TColors.black : TColors.white,
          indicatorColor: darkMode
              ? TColors.white.withOpacity(0.1)
              : TColors.black.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
            NavigationDestination(icon: Icon(Iconsax.shop), label: "Store"),
            NavigationDestination(icon: Icon(Iconsax.heart), label: "WishList"),
            NavigationDestination(icon: Icon(Iconsax.user), label: "Profile"),
          ],
        ),
      ),
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: [...controller.screens],
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  late Rx<int> selectedIndex = 0.obs;

  NavigationController({int? initialIndex}) {
    if (initialIndex != null) {
      selectedIndex = initialIndex.obs;
    } else {
      selectedIndex = 0.obs;
    }
  }

  final screens = [
    HomeScreen(),
    //SellProductScreen(),
    StoreScreen(),
    WishlistScreen(),
    SettingsScreen()
  ];
}
