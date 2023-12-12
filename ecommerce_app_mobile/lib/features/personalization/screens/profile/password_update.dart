import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:ecommerce_app_mobile/features/personalization/controllers/profile_controller.dart';
import 'package:ecommerce_app_mobile/features/personalization/screens/profile/profile_screen.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PasswordUpdateScreen extends StatefulWidget {
  const PasswordUpdateScreen({Key? key}) : super(key: key);

  @override
  State<PasswordUpdateScreen> createState() => _PasswordUpdateScreenState();
}

class _PasswordUpdateScreenState extends State<PasswordUpdateScreen> {
  final controller1 = Get.put(ProfileController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đổi mật khẩu'),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Get.off(const ProfileScreen()),
            icon: const Icon(Iconsax.arrow_left)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: FutureBuilder(
            future: controller1.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel userModel = snapshot.data as UserModel;

                  //Controllers
                  final oldPassword = TextEditingController();
                  final newPassword = TextEditingController();
                  final retypePassword = TextEditingController();

                  return Column(
                    children: [
                      /// -- Form Fields
                      Obx(
                        () => Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: oldPassword,
                                obscureText: !controller1.showPassword.value,
                                validator: (value) =>
                                    TValidator.validateOldPassword(
                                        value, userModel.password),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  label: const Text('Old Password'),
                                  prefixIcon:
                                      const Icon(Iconsax.password_check),
                                  suffixIcon: IconButton(
                                    icon: Icon(controller1.showPassword.value
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      controller1.showPassword.value =
                                          !controller1.showPassword.value;
                                      // Toggle showPassword state
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),

                              TextFormField(
                                controller: newPassword,
                                obscureText: !controller1.showNewPassword.value,
                                validator: TValidator.validatePassword,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  label: const Text('New Password'),
                                  prefixIcon:
                                      const Icon(Iconsax.password_check),
                                  suffixIcon: IconButton(
                                    icon: Icon(controller1.showNewPassword.value
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      controller1.showNewPassword.value =
                                          !controller1.showNewPassword.value;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),

                              TextFormField(
                                controller: retypePassword,
                                obscureText:
                                    !controller1.showRetypePassword.value,
                                validator: (value) =>
                                    TValidator.validateRetypePassword(
                                        value, newPassword.text),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  label: const Text('Retype Password'),
                                  prefixIcon:
                                      const Icon(Iconsax.password_check),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                        controller1.showRetypePassword.value
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                    onPressed: () {
                                      controller1.showRetypePassword.value =
                                          !controller1.showRetypePassword.value;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),

                              /// -Form Submit Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      final userData = UserModel(
                                        id: userModel.id,
                                        firstName: userModel.firstName,
                                        lastName: userModel.lastName,
                                        email: userModel.email,
                                        phoneNumber: userModel.phoneNumber,
                                        password: newPassword.text.trim(),
                                        avatar_imgURL: userModel.avatar_imgURL,
                                      );

                                      await controller1.updateUser(userData);
                                      await controller1
                                          .updatePassword(userModel);
                                      // Navigator.pop(context,
                                      //     MaterialPageRoute(builder: (context) => ProfileScreen()));
                                      Get.off(() => const ProfileScreen());
                                    }
                                  },
                                  child: const Text(
                                    'Cập nhật mật khẩu',
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
