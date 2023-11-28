import 'package:ecommerce_app_mobile/Service/Auth/fb_auth_provider.dart';
import 'package:ecommerce_app_mobile/Service/Auth/firebaseauth_provider.dart';
import 'package:ecommerce_app_mobile/Service/Auth/gg_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final isloginWithEmail = false.obs;
  final isloginWithGg = false.obs;
  final isloginWithFb = false.obs;

  final isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isFacebookLoading = false.obs;

  final email = TextEditingController();
  final password = TextEditingController();

  //log in ưith email and password
  Future<User> logInWithEmail() async {
    isloginWithGg.value = false;
    isloginWithEmail.value = true;
    return FirebaseAuthProvider.firebaseAuthProvider.logIn(
      email: email.text,
      password: password.text,
    );
  }

  //log in with gg
  Future<UserCredential?> logInWithGoogle() async {
    isloginWithGg.value = true;
    isGoogleLoading.value = true;
    UserCredential? userCredential =
        await GgAuthProvider.ggProvider.signInWithGoogle();
    isGoogleLoading.value = false;
    return userCredential;
  }

  Future<UserCredential?> logInWithFb() async {
    isloginWithFb.value = true;
    isloginWithGg.value = false;
    return await FbAuthProvider.fbProvider.signInWithFacebook();
  }

  Future<void> logOut() async {
    if (isloginWithGg.value == true) {
      await GgAuthProvider.ggProvider.logOutGoogle();
      isloginWithGg.value = false;
    } else if (isloginWithEmail.value == true) {
      isloginWithEmail.value = false;
      await FirebaseAuthProvider.firebaseAuthProvider.logOut();
    } else {
      isloginWithFb.value = false;
      await FbAuthProvider.fbProvider.logOutFb();
    }
  }
}
