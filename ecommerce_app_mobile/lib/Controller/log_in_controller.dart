import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/authentication_repository.dart';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInController extends GetxController {
  static SignInController get instance => Get.find();
  var controller = Get.put(AuthenticationRepository());
  var userRepo = Get.put(UserRepository());

  var deviceStorage = GetStorage('app-setting-configs');

  var isPasswordObscure = true.obs;
  var isRememberMe = true.obs;

  void showHiddenPassword() {}

  void rememberMe(bool isRememberMe) {}

  final email = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNumber = TextEditingController();

  final isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isFacebookLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    final savedEmail = deviceStorage.read('userEmail');
    if (savedEmail != Null && savedEmail != null) {
      email.text = savedEmail;
    }
  }

  Future<void> signIn(String email, String password) async {
    if (isRememberMe.value) {
      await deviceStorage.write('userEmail', email);
    }
    isLoading.value = true;
    await AuthenticationRepository.instance
        .loginUserWithEmailAndPassword(email, password);
    isLoading.value = false;
  }

  Future<void> googleSignIn() async {
    try {
      isGoogleLoading.value = true;
      final auth = AuthenticationRepository.instance;
      await auth.signInWithGoogle();

      isGoogleLoading.value = false;

      final names = auth.firebaseUser.value!.displayName!.split(' ');

      final model = UserModel(
        firstName: names[0],
        lastName: names.sublist(1).join(' '),
        email: auth.firebaseUser.value!.email!,
        phoneNumber: auth.firebaseUser.value!.phoneNumber ?? '000000000',
        password: '',
        address: [],
        wishlist: [],
        bankAccount: '',
        cart: [],
        isSell: false,
        totalConsumption: 0,
        userName: '',
        voucher: [],
      );
      if (!await userRepo.isEmailExisted(model.email)) {
        await userRepo.createUser(model);
        auth.setInitialScreen(auth.firebaseUser.value);
      }
      auth.setInitialScreen(auth.firebaseUser.value);
    } catch (e) {
      isGoogleLoading.value = false;
      Get.snackbar(
        'Lỗi',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      GoogleSignIn().signOut();
    }
  }

  Future<void> facebookSignIn() async {
    try {
      isFacebookLoading.value = true;
      final auth = AuthenticationRepository.instance;
      await auth.signInWithFacebook();
      isFacebookLoading.value = false;

      final names = auth.firebaseUser.value!.displayName!.split(' ');

      final model = UserModel(
        firstName: names[0],
        lastName: names.sublist(1).join(' '),
        email: auth.firebaseUser.value!.email!,
        phoneNumber: auth.firebaseUser.value!.phoneNumber ?? '000000000',
        password: '',
        address: [],
        wishlist: [],
        bankAccount: '',
        cart: [],
        isSell: false,
        totalConsumption: 0,
        userName: '',
        voucher: [],
      );
      if (!await userRepo.isEmailExisted(model.email)) {
        await userRepo.createUser(model);
        auth.setInitialScreen(auth.firebaseUser.value);
      }
      auth.setInitialScreen(auth.firebaseUser.value);
    } catch (e) {
      isFacebookLoading.value = false;
      Get.snackbar(
        'Lỗi',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      // FacebookAuth.instance.logOut();
    }
  }
}
