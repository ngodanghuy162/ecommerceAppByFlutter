import 'package:ecommerce_app_mobile/Service/Auth/firebaseauth_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SearchControllerX extends GetxController {
  static SearchControllerX get instance => Get.find();
  RxBool isSearching = false.obs;
  final keySearch = TextEditingController();
}
