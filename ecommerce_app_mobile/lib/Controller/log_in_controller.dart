import 'package:ecommerce_app_mobile/Service/Auth/firebaseauth_provider.dart';
import 'package:ecommerce_app_mobile/Service/Auth/google_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isFacebookLoading = false.obs;

  final email = TextEditingController();
  final password = TextEditingController();

  //log in ưith email and password
  Future<User> logIn() async {
    return FirebaseAuthProvider.firebaseAuthProvider.logIn(
      email: email.text,
      password: password.text,
    );
  }

  //log in with gg
  Future<UserCredential?> logInWithGoogle() async {
    try {
      isGoogleLoading.value = true;
      UserCredential? userCredential =
          await GoogleProvider.ggProvider.signInWithGoogle();
      isGoogleLoading.value = false;
      return userCredential;
    } catch (e) {
      isGoogleLoading.value = false;
      print("Error logging in with Google: $e"); // In ra thông tin lỗi
      Get.snackbar("Failed to login with Google",
          "An error occurred during login."); // Hoặc sử dụng thông báo mặc định
    }
    return null;
  }
}
