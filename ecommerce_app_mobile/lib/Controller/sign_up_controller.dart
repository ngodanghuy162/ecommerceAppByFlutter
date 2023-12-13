import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/authentication_repository.dart';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();
  var controller = Get.put(AuthenticationRepository());

  var userRepo = Get.put(UserRepository());

  var isPasswordObscure = true.obs;
  var isRememberMe = true.obs;

  void showHiddenPassword() {}

  Future<bool> isEmailExisted() async {
    return await userRepo.isEmailExisted(email.text);
  }

  final email = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNumber = TextEditingController();

  Future<bool> registerUser(String email, String password) async {
    return await AuthenticationRepository.instance
        .createUserWithEmailAndPassword(email, password);
  }

  Future<bool> isDuplicateEmail() async {
    return controller.isDuplicateEmail();
  }

  createUser(UserModel userModel) async {
    if (await registerUser(userModel.email, userModel.password!)) {
      userRepo.createUser(userModel);
    }
  }
}
