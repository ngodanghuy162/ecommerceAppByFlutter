import 'package:ecommerce_app_mobile/common/styles/spacing_styles.dart';
import 'package:ecommerce_app_mobile/common/widgets/login_signup/form_divider.dart';
import 'package:ecommerce_app_mobile/common/widgets/login_signup/social_button.dart';
import 'package:ecommerce_app_mobile/features/authentication/screens/login/widgets/login_header.dart';
import 'package:ecommerce_app_mobile/features/authentication/screens/login/widgets/login_form.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              //Logo, title and sub-titlte
              const TLoginHeader(),

              //Form
              const TLoginForm(),

              //Divider
              TFormDivider(dividerText: TTexts.orSignInWith.capitalize!),

              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              //Footer
              TSocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}
