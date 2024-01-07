import 'package:ecommerce_app_mobile/Controller/sign_up_controller.dart';
import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:ecommerce_app_mobile/features/authentication/screens/signup/widgets/terms_conditions_checkbox.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/constants/text_strings.dart';
import 'package:ecommerce_app_mobile/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TSignupForm extends StatefulWidget {
  const TSignupForm({
    super.key,
  });

  @override
  State<TSignupForm> createState() => _TSignupFormState();
}

class _TSignupFormState extends State<TSignupForm> {
  final controller = Get.put(SignUpController());
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          //FirstName and LastName
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: TValidator.validateName,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  controller: controller.lastName,
                  validator: TValidator.validateName,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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

          // //,Username
          // TextFormField(
          //   expands: false,
          //   decoration: const InputDecoration(
          //     labelText: TTexts.username,
          //     prefixIcon: Icon(Iconsax.user_edit),
          //   ),
          // ),
          // const SizedBox(height: TSizes.spaceBtwInputFields),

          //Email
          TextFormField(
            controller: controller.email,
            validator: TValidator.validateEmail,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            expands: false,
            decoration: const InputDecoration(
              labelText: TTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          //Phone number
          TextFormField(
            controller: controller.phoneNumber,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: TValidator.validatePhoneNumber,
            expands: false,
            decoration: const InputDecoration(
              labelText: TTexts.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

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
          const SizedBox(height: TSizes.spaceBtwSections),

          //Terms, and Conditions checkbox
          const TTermsAndConditionsCheckbox(),
          //Sign up button
          const SizedBox(height: TSizes.spaceBtwSections),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  UserModel userModel = UserModel(
                    firstName: controller.firstName.text,
                    lastName: controller.lastName.text,
                    email: controller.email.text,
                    phoneNumber: controller.phoneNumber.text,
                    password: controller.password.text,
                    address: [],
                    wishlist: [],
                    bankAccount: '',
                    cart: [],
                    isSell: false,
                    totalConsumption: 0,
                    userName: '',
                    voucher: [],
                  );

                  SignUpController.instance.createUser(userModel);
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
