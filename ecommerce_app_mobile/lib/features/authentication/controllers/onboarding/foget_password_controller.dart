import 'package:ecommerce_app_mobile/Service/repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  final email = TextEditingController();

  void forgetPassword() {
    AuthenticationRepository.instance.resetPassword(email.text);
  }
}
