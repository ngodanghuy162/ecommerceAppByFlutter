import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

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
      // Get.to(LoginScreen());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.animateToPage(page,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  void skipPage() {
    pageController.animateToPage(3 - 1,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }
}
