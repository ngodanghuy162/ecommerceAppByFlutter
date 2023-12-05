import 'package:ecommerce_app_mobile/Service/Auth/firebaseauth_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final phoneNumber = TextEditingController();

  Future<void> registerUser() async {
    await FirebaseAuthProvider.firebaseAuthProvider.createUser(
        firstName: firstName.text,
        lastName: lastName.text,
        userName: userName.text,
        email: email.text,
        password: password.text,
        phoneNumber: phoneNumber.text);
  }
}
