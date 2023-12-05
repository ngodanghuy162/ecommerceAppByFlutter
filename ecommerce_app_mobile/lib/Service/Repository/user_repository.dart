import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<bool> isEmailExisted(String email) async {
    final snapshot = await _db
        .collection('Users')
        .where(
          'email',
          isEqualTo: email,
        )
        .get()
        .catchError(
      (error) {
        if (kDebugMode) {
          print(error);
        }
      },
    );
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e));
    return userData.isNotEmpty;
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot = await _db
        .collection('Users')
        .where(
          'email',
          isEqualTo: email,
        )
        .get()
        .catchError(
      (error) {
        if (kDebugMode) {
          print(error);
        }
      },
    );

    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<void> updatePassword(UserModel userModel) async {
    await FirebaseAuth.instance.currentUser!
        .updatePassword(userModel.password!);
  }

  Future<void> updateUserDetail(UserModel userModel) async {
    await _db
        .collection('Users')
        .doc(userModel.id)
        .update(userModel.toMap())
        .whenComplete(() => Get.snackbar(
              "Thành công",
              "Tài khoản của bạn đã được cập nhật",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.1),
              colorText: Colors.green,
              duration: const Duration(seconds: 1),
            ))
        .catchError((error, stacktrace) {
      () => Get.snackbar(
            'Lỗi',
            'Có gì đó không đúng, thử lại?',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.red,
          );
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  Future<List<UserModel>> getAllUsers() async {
    final snapshot = await _db.collection('Users').get();
    final userData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();

    return userData;
  }

  createUser(UserModel userModel) async {
    await _db
        .collection('Users')
        .add(userModel.toMap())
        .whenComplete(
          () => Get.snackbar(
            'Thành công',
            'Tài khoản của bạn đã được tạo',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
          ),
        )
        .catchError((error, stacktrace) {
      () => Get.snackbar(
            'Lỗi',
            'Có gì đó không đúng, thử lại?',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.red,
          );
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
