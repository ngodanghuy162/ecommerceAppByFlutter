import 'dart:async';

import 'package:ecommerce_app_mobile/features/authentication/controllers/mail_verification/mail_verification_controller.dart';
import 'package:ecommerce_app_mobile/features/authentication/screens/login/login_screen.dart';
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/constants/text_strings.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class VerifyEmailScreen extends StatefulWidget {
  VerifyEmailScreen({super.key});

  Timer? timer;
  int start = 60;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  void restartCountDown() {
    setState(() {
      widget.start = 60;
    });
  }

  void startCountdown() {
    const oneSec = Duration(seconds: 1);
    widget.timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (widget.start == 0) {
          setState(() {
            timer.cancel();
            widget.start = 0;
          });
        } else {
          setState(() {
            widget.start--;
            // print(widget.start);
          });
        }
      },
    );
  }

  bool isCountdownDone() {
    return widget.start <= 0;
  }

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MailVerificationController());
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
                'support@hcmmuseum.com',
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
                  onPressed: () {
                    controller.manuallyCheckEmailVerification();
                  },
                  child: const Text(TTexts.tContinue),
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    if (isCountdownDone()) {
                      controller.sendVerification();
                      restartCountDown();
                      startCountdown();
                    }
                  },
                  child: isCountdownDone()
                      ? const Text(TTexts.resendEmail)
                      : Text('Resend after ${widget.start}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
