import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/authentication_repository.dart';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SettingsController extends GetxController {
  static SettingsController get instance => Get.find();

  final _userRepo = Get.put(UserRepository());
  Future<UserModel> getUserData() async {
    while (_userRepo.currentUserModel == null) {
      await _userRepo.updateUserDetails();
    }
    print('ókok');

    return _userRepo.currentUserModel!;
  }
}
