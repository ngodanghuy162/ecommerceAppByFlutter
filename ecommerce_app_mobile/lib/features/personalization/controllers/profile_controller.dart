import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/authentication_repository.dart';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  //Repositories
  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());
  var showPassword = false.obs;
  var showNewPassword = false.obs;
  var showRetypePassword = false.obs;

  UserModel? crtUser;

  getUserData() {
    final email = _authRepo.firebaseUser.value?.email;
    if (email != null) {
      return _userRepo.getUserDetails(email);
    } else {
      SmartDialog.showNotify(
        msg: 'You have to login to continue.',
        notifyType: NotifyType.failure,
        displayTime: const Duration(seconds: 1),
      );
    }
  }

  String getProviderId() {
    final info = FirebaseAuth.instance.currentUser!.providerData.first;
    return info.providerId;
  }

  updateUser(UserModel userModel) async {
    await _userRepo.updateUserDetail(userModel);
    await _userRepo.updateUserDetails();
  }

  Future<void> updatePassword(UserModel userModel) async {
    await _userRepo.updatePassword(userModel);
  }
}
