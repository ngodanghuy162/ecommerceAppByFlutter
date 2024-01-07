import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/features/personalization/controllers/profile_controller.dart';
import 'package:ecommerce_app_mobile/features/personalization/screens/profile/profile_screen.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({Key? key}) : super(key: key);

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final controller1 = Get.put(ProfileController());
  final userRepository = Get.put(UserRepository());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: const Text(
          'Change profile info',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backOnPress: () {
          Get.back();
        },
        showBackArrow: true,
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
                  final email = TextEditingController(text: userModel.email);
                  final firstName =
                      TextEditingController(text: userModel.firstName);
                  final lastName =
                      TextEditingController(text: userModel.lastName);
                  final phoneNumber =
                      TextEditingController(text: userModel.phoneNumber);

                  return Column(
                    children: [
                      /// -- Form Fields
                      Form(
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: userModel.email,
                              enabled: false,
                              decoration: const InputDecoration(
                                label: Text('Email'),
                                prefixIcon: Icon(Icons.email),
                              ),
                            ),
                            const SizedBox(height: 32),
                            TextFormField(
                              controller: firstName,
                              decoration: const InputDecoration(
                                label: Text('FirstName'),
                                prefixIcon: Icon(Iconsax.user),
                              ),
                            ),
                            const SizedBox(height: 32),
                            TextFormField(
                              controller: lastName,
                              decoration: const InputDecoration(
                                label: Text('LastName'),
                                prefixIcon: Icon(Iconsax.user),
                              ),
                            ),
                            const SizedBox(height: 32),
                            TextFormField(
                              controller: phoneNumber,
                              decoration: const InputDecoration(
                                label: Text('PhoneNumber'),
                                prefixIcon: Icon(Icons.phone),
                              ),
                            ),
                            const SizedBox(height: 32),
                            // TextFormField(
                            //   controller: password,
                            //   //obscureText: true, thử đi
                            //   decoration: const InputDecoration(
                            //     label: Text('Password'), prefixIcon: Icon(Iconsax.password_check),
                            //   ),
                            // ),
                            // const SizedBox(height: 32),

                            /// -Form Submit Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  do {
                                    await userRepository.updateUserDetails();
                                  } while (
                                      userRepository.currentUserModel == null);
                                  final currentUserModel =
                                      userRepository.currentUserModel!;

                                  final userData = UserModel(
                                    id: userModel.id,
                                    firstName: firstName.text.trim(),
                                    lastName: lastName.text.trim(),
                                    email: email.text.trim(),
                                    phoneNumber: phoneNumber.text.trim(),
                                    avatar_imgURL: userModel.avatar_imgURL,
                                    address: currentUserModel.address,
                                    cart: currentUserModel.cart,
                                    bankAccount: currentUserModel.bankAccount,
                                    isSell: currentUserModel.isSell,
                                    password: currentUserModel.password,
                                    totalConsumption:
                                        currentUserModel.totalConsumption,
                                    userName: currentUserModel.userName,
                                    voucher: currentUserModel.voucher,
                                    wishlist: currentUserModel.wishlist,
                                  );

                                  await controller1.updateUser(userData);
                                  // Navigator.pop(context,
                                  //     MaterialPageRoute(builder: (context) => ProfileScreen()));
                                  Get.off(() => const ProfileScreen());
                                },
                                // style: ElevatedButton.styleFrom(
                                //   backgroundColor: TColors.primary,
                                //   side: BorderSide.none,
                                //   shape: const StadiumBorder(),
                                // ),
                                child: const Text('Update',
                                    style: TextStyle(
                                        color: TColors.light, fontSize: 18)),
                              ),
                            )
                          ],
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
