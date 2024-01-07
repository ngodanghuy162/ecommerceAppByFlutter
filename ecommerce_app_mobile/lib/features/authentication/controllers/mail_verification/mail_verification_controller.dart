import 'dart:async';
import 'package:ecommerce_app_mobile/Service/repository/authentication_repository.dart';
import 'package:ecommerce_app_mobile/common/widgets/success_screen/success_screen.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class MailVerificationController extends GetxController {
  late Timer _timer;
  @override
  void onInit() {
    super.onInit();
    sendVerification();
    setTimerForAutoRedirect();
  }

  Future<void> sendVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
    } catch (e) {
      SmartDialog.showNotify(
        msg: e.toString(),
        notifyType: NotifyType.failure,
        displayTime: const Duration(seconds: 1),
      );
    }
  }

  void setTimerForAutoRedirect() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user!.emailVerified) {
        _timer.cancel();
        Get.off(
          SuccessScreen(
            image: TImages.staticSuccessIllustration,
            title: TTexts.yourAccountCreatedTitle,
            subtitle: TTexts.yourAccountCreatedSubTitle,
            callback: () {
              AuthenticationRepository.instance.setInitialScreen(user);
            },
          ),
        );
      }
    });
  }

  void manuallyCheckEmailVerification() {
    FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;
    if (!user!.emailVerified) {
      Get.snackbar(
        'Account not verified',
        'Check your email and try again',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.redAccent,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
      );
    }
  }
}
