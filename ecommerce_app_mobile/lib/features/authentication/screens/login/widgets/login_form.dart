import 'package:ecommerce_app_mobile/Controller/log_in_controller.dart';
import 'package:ecommerce_app_mobile/common/dialog/dialog.dart';
import 'package:ecommerce_app_mobile/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:ecommerce_app_mobile/features/authentication/screens/signup/sign_up_screen.dart';
import 'package:ecommerce_app_mobile/features/authentication/screens/signup/verify_email.dart';
import 'package:ecommerce_app_mobile/navigation_menu.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            //Email
            TextFormField(
              controller: LoginController.instance.email,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: TTexts.email,
              ),
            ),
            const SizedBox(
              height: TSizes.spaceBtwInputFields,
            ),

            //Password
            TextFormField(
              controller: LoginController.instance.password,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                suffixIcon: Icon(Iconsax.eye_slash),
                labelText: TTexts.password,
              ),
            ),
            const SizedBox(
              height: TSizes.spaceBtwInputFields / 2,
            ),

            //Remember me and forget the password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Remember me
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    const Text(TTexts.rememberMe)
                  ],
                ),

                //Forget the password
                TextButton(
                  onPressed: () => Get.to(() => const ForgetPassword()),
                  child: const Text(TTexts.forgetPassword),
                ),
              ],
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            //Sign in, log in
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  var currentAuthUser = await LoginController.instance.logIn();
                  if (currentAuthUser.emailVerified) {
                    Get.snackbar(
                        "Login sucess", "Now you can begin your adventure ");
                    Future.delayed(const Duration(seconds: 1), () {
                      Get.to(() => const NavigationMenu());
                    });
                  } else {
                    await showDialogOnScreen(
                      context: context,
                      title: "Haven't verify email",
                      description: "You need to verify your email first",
                      onOkPressed: () {
                        Get.to(() => const VerifyEmailScreen());
                      },
                    );
                  }
                },
                child: const Text(TTexts.signIn),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems),

            //Sign up
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.to(() => const SignUpScreen()),
                child: const Text(TTexts.createAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
