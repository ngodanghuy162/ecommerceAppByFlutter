import 'package:ecommerce_app_mobile/common/widgets/login_signup/form_divider.dart';
import 'package:ecommerce_app_mobile/common/widgets/login_signup/social_button.dart';
import 'package:ecommerce_app_mobile/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Title
              Text(
                TTexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              //Form
              const TSignupForm(),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Divider
              TFormDivider(dividerText: TTexts.orSignUpWith.capitalize!),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Social button
              TSocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}
