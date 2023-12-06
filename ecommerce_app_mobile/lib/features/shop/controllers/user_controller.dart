
import 'package:ecommerce_app_mobile/repository/user_repository.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();
  final _userRepo = Get.put(UserRepository());


  getUserDocumentId(String id) async {
    return await _userRepo.getUserDocumentId(id);
  }
}