import 'package:ecommerce_app_mobile/Controller/log_in_controller.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
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
          child: Obx(
            () => IconButton(
              onPressed: () async {
                if (!controller.isLoading.value &&
                    !controller.isFacebookLoading.value) {
                  await controller.logInWithGoogle();
                }
              },
              icon: controller.isLoading.value ||
                      controller.isFacebookLoading.value
                  ? CircularProgressIndicator()
                  : Image(
                      height: TSizes.iconMd,
                      width: TSizes.iconMd,
                      image: AssetImage(
                        TImages.google,
                      ),
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
