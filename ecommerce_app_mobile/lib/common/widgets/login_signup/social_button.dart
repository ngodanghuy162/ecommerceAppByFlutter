import 'package:ecommerce_app_mobile/Controller/log_in_controller.dart';
import 'package:ecommerce_app_mobile/Service/Auth/google_auth.dart';
import 'package:ecommerce_app_mobile/common/dialog/dialog.dart';
import 'package:ecommerce_app_mobile/navigation_menu.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TSocialButtons extends StatelessWidget {
  const TSocialButtons({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: TColors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            onPressed: () async {
              try {
                UserCredential? userCredential =
                    await controller.logInWithGoogle();
                if (userCredential != null) {
                  Get.snackbar("Sucess", "You are login with gooogle success");
                  Future.delayed(const Duration(seconds: 1), () {
                    Get.offAll(() => const NavigationMenu());
                  });
                }
                print("Log in ok");
              } on Exception {
                await showDialogOnScreen(
                    context: context,
                    title: "Loi dn google",
                    description: "try again");
              }
            },
            icon: const Image(
              height: TSizes.iconMd,
              width: TSizes.iconMd,
              image: AssetImage(
                TImages.google,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: TSizes.spaceBtwItems,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: TColors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
              onPressed: () {},
              icon: const Image(
                height: TSizes.iconMd,
                width: TSizes.iconMd,
                image: AssetImage(
                  TImages.facebook,
                ),
              )),
        ),
      ],
    );
  }
}
