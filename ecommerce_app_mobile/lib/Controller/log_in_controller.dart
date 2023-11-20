import 'package:ecommerce_app_mobile/Service/Auth/firebaseauth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();

  Future<User> logIn() async {
    return FirebaseAuthProvider.firebaseAuthProvider.logIn(
      email: email.text,
      password: password.text,
    );
  }
}
