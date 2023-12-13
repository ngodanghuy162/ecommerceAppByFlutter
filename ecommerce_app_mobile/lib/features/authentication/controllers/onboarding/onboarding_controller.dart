import 'package:ecommerce_app_mobile/features/authentication/screens/login/login_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  final PageController pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  void updatePageIndicator(index) {
    currentPageIndex.value = index;
  }

  void dotNavigationClick(index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  void nextPage() {
    if (currentPageIndex.value == 3 - 1) {
      Get.offAll(const LoginScreen());
      final deviceStorage = GetStorage('app-setting-configs');
      deviceStorage.write('isFirstTime', false);
    } else {
      int page = currentPageIndex.value + 1;
      pageController.animateToPage(page,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  void skipPage() {
    Get.offAll(
      const LoginScreen(),
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
    final deviceStorage = GetStorage('app-setting-configs');
    deviceStorage.write('isFirstTime', false);
  }
}
