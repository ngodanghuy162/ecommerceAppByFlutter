import 'package:ecommerce_app_mobile/Controller/log_in_controller.dart';
import 'package:ecommerce_app_mobile/common/widgets/loading/custom_loading.dart';
import 'package:ecommerce_app_mobile/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:ecommerce_app_mobile/features/authentication/screens/signup/sign_up_screen.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/constants/text_strings.dart';
import 'package:ecommerce_app_mobile/utils/validators/validation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

// ignore: must_be_immutable
class TLoginForm extends StatefulWidget {
  const TLoginForm({
    super.key,
  });

  @override
  State<TLoginForm> createState() => _TLoginFormState();
}

class _TLoginFormState extends State<TLoginForm> {
  final controller = Get.put(SignInController());

  final _formKey = GlobalKey<FormState>();

  final btnController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            //Email
            TextFormField(
              controller: controller.email,
              validator: TValidator.validateEmail,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
              controller: controller.password,
              obscureText: controller.isPasswordObscure.value,
              validator: TValidator.validatePassword,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  icon: controller.isPasswordObscure.value
                      ? const Icon(Iconsax.eye)
                      : const Icon(Iconsax.eye_slash),
                  onPressed: () {
                    setState(() {
                      controller.isPasswordObscure.value =
                          !controller.isPasswordObscure.value;
                    });
                  },
                ),
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
                    Checkbox(
                      value: controller.isRememberMe.value,
                      onChanged: (value) {
                        setState(() {
                          controller.isRememberMe.value =
                              !controller.isRememberMe.value;
                        });
                      },
                    ),
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

            //Sign in
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    SmartDialog.showLoading(
                      animationType: SmartAnimationType.scale,
                      builder: (_) => const CustomLoading(),
                    );
                    try {
                      await controller.signIn(
                          controller.email.text, controller.password.text);
                    } catch (error) {
                      if (kDebugMode) {
                        print(error);
                      }
                    } finally {
                      await SmartDialog.dismiss();
                    }
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
