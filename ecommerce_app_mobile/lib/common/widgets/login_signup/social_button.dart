import 'package:ecommerce_app_mobile/Controller/log_in_controller.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class TSocialButtons extends StatelessWidget {
  TSocialButtons({
    super.key,
  });

  final controller = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: TColors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Obx(
            () => IconButton(
                onPressed: controller.isLoading.value ||
                        controller.isGoogleLoading.value
                    ? () {}
                    : controller.googleSignIn,
                icon: const Image(
                  height: TSizes.iconMd,
                  width: TSizes.iconMd,
                  image: AssetImage(
                    TImages.google,
                  ),
                )),
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
          child: Obx(
            () => IconButton(
                onPressed: controller.isLoading.value ||
                        controller.isFacebookLoading.value
                    ? () {}
                    : controller.facebookSignIn,
                icon: const Image(
                  height: TSizes.iconMd,
                  width: TSizes.iconMd,
                  image: AssetImage(
                    TImages.facebook,
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
