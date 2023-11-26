import 'package:ecommerce_app_mobile/Service/Auth/firebaseauth_provider.dart';
import 'package:ecommerce_app_mobile/common/dialog/dialog.dart';
import 'package:ecommerce_app_mobile/common/widgets/success_screen/success_screen.dart';
import 'package:ecommerce_app_mobile/features/authentication/screens/login/login_screen.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/constants/text_strings.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Hide back button
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Get.offAll(const LoginScreen()),
              icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              //Image
              Image(
                image: const AssetImage(TImages.deliveredEmailIllustration),
                width: THelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Title and sub-title
              Text(
                TTexts.confirmEmail,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                'support@shopapp.com',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                TTexts.confirmEmailSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuthProvider
                        .firebaseAuthProvider.currentFirebaseUser!
                        .reload();
                    // go to success screen neu verify roi
                    if (FirebaseAuthProvider.firebaseAuthProvider
                        .currentFirebaseUser!.emailVerified) {
                      Get.to(
                        () => SuccessScreen(
                          image: TImages.staticSuccessIllustration,
                          title: TTexts.yourAccountCreatedTitle,
                          subtitle: TTexts.yourAccountCreatedSubTitle,
                          callback: () => Get.offAll(() => const LoginScreen()),
                        ),
                      );
                    } else {
                      await showDialogOnScreen(
                          context: context,
                          title: "Email isn't verified",
                          description: "Pls try to verify your email again");
                    }
                  },
                  child: const Text(TTexts.tContinue),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    await FirebaseAuthProvider.firebaseAuthProvider
                        .sendEmailVerify();
                  },
                  child: const Text(TTexts.resendEmail),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
