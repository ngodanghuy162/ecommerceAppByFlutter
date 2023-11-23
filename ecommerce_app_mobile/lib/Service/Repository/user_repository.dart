import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Auth/firebaseauth_provider.dart';
import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UserRepository {
  final usersCollection = FirebaseFirestore.instance.collection('Users');

  // Khai báo static để lưu trữ thể hiện duy nhất của UserRepository
  static final UserRepository userRepository = UserRepository._internal();

  // Phương thức factory để trả về thể hiện duy nhất của UserRepository
  factory UserRepository() {
    return userRepository;
  }

  // Hàm khởi tạo internal (chỉ được gọi bởi factory constructor)
  UserRepository._internal();

  //get user by nothing
  Future<CloudUserModel> get currentCloudUser async {
    String email = FirebaseAuthProvider
        .firebaseAuthProvider.currentFirebaseUser!.email
        .toString();
    final snapshot = await usersCollection
        .where(
          'email',
          isEqualTo: email,
        )
        .get();

    final userData =
        snapshot.docs.map((e) => CloudUserModel.fromSnapshot(e)).single;
    return userData;
  }

  //get user by email
  Future<CloudUserModel?> getCloudUserByEmail(String email) async {
    final snapshot = await usersCollection
        .where(
          'email',
          isEqualTo: email,
        )
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Nếu tìm thấy người dùng, trả về CloudUserModel
      final userData =
          snapshot.docs.map((e) => CloudUserModel.fromSnapshot(e)).single;
      return userData;
    } else {
      // Nếu không tìm thấy người dùng, trả về null
      return null;
    }
  }

//tao user
  Future<void> createUser(CloudUserModel cloudUserModel) async {
    await usersCollection
        .add(cloudUserModel.toMap())
        .whenComplete(
          () => Get.snackbar(
            'Success',
            'Your acount has created successfully.Now you have to verify your email to use',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
          ),
        )
        // ignore: body_might_complete_normally_catch_error
        .catchError((error, stacktrace) {
      () => Get.snackbar(
            'Fault',
            'Try again babi',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.red,
          );
      print(error.toString());
    });
  }
}
