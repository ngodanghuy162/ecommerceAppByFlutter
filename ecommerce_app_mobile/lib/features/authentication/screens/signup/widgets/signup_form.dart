import 'package:ecommerce_app_mobile/Controller/sign_up_controller.dart';
import 'package:ecommerce_app_mobile/Service/Auth/auth_exception.dart';
import 'package:ecommerce_app_mobile/common/dialog/dialog.dart';
import 'package:ecommerce_app_mobile/features/authentication/screens/signup/verify_email.dart';
import 'package:ecommerce_app_mobile/features/authentication/screens/signup/widgets/terms_conditions_checkbox.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TSignupForm extends StatelessWidget {
  const TSignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(SignUpController());
    var signUpController = SignUpController.instance;
    return Form(
      child: Column(
        children: [
          //FirstName and LastName
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: signUpController.firstName,
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: TTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: signUpController.lastName,
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: TTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          //Username
          TextFormField(
            controller: signUpController.userName,
            expands: false,
            decoration: const InputDecoration(
              labelText: TTexts.username,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          //Email
          TextFormField(
            controller: signUpController.email,
            expands: false,
            decoration: const InputDecoration(
              labelText: TTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          //Phone number
          TextFormField(
            controller: signUpController.phoneNumber,
            expands: false,
            decoration: const InputDecoration(
              labelText: TTexts.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          //Password
          TextFormField(
            controller: signUpController.password,
            obscureText: true,
            expands: false,
            decoration: const InputDecoration(
              labelText: TTexts.password,
              prefixIcon: Icon(Iconsax.password_check),
              suffixIcon: Icon(Iconsax.eye_slash),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          //Terms and Conditions checkbox
          const TTermsAndConditionsCheckbox(),
          //Sign up button
          const SizedBox(height: TSizes.spaceBtwSections),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await signUpController.registerUser();
                  await showDialogOnScreen(
                      context: context,
                      title: 'Create Acount Success',
                      description:
                          'Now you have to verify email to use your account',
                      onOkPressed: () {
                        Get.to(() => const VerifyEmailScreen());
                      },
                      showCancelButton: false);
                } on EmailAlreadyInUseAuthException {
                  // ignore: use_build_context_synchronously
                  await showDialogOnScreen(
                    context: context,
                    title: 'Failed to register',
                    description: 'Email has been used',
                    onOkPressed: () {}, // Hàm trống
                  );
                } on WeakPasswordAuthException {
                  await showDialogOnScreen(
                    context: context,
                    title: 'Failed to register',
                    description: 'Weak Password',
                    onOkPressed: () {}, // Hàm trống
                  );
                } on InvalidEmailException {
                  await showDialogOnScreen(
                    context: context,
                    title: 'Failed to register',
                    description: 'Invalid Email',
                    onOkPressed: () {}, // Hàm trống
                  );
                } on GenericAuthException {
                  await showDialogOnScreen(
                    context: context,
                    title: 'Failed to register',
                    description: 'Somthing went wrong',
                    onOkPressed: () {}, // Hàm trống
                  );
                }
              },
              child: const Text(TTexts.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}
