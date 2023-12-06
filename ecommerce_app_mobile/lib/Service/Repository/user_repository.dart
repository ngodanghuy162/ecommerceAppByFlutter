import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './user_model_field.dart';

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

  Future<void> addProductToCart(ProductModel productModel) async {
    final usersCollection = _db.collection('Users');
    try {
      /*  String currentUserId =
          await currentCloudUser.then((value) => value.userId);*/
      final snapshot = await usersCollection
          .where(
            userIdFieldName,
            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
          )
          .get();
      if (snapshot.docs.isNotEmpty) {
        var firstDocument = snapshot.docs[0];
        var documentId = firstDocument.id;
        if (productModel.id!.isNotEmpty) {
          bool isProductInCart =
              firstDocument[cartFieldName].contains(productModel.id);
          if (!isProductInCart) {
            await usersCollection.doc(documentId).update({
              cartFieldName: FieldValue.arrayUnion([productModel.id]),
            });
            Get.snackbar('Ok', "Them vao cart ok");
          } else {
            Get.snackbar('Error', "Product is already in cart");
            return;
          }
        } else {
          String? productId = await ProductRepository.instance
              .getDocumentIdForProduct(productModel);
          bool isProductInCart =
              firstDocument[cartFieldName].contains(productId);
          if (!isProductInCart) {
            await usersCollection.doc(documentId).update({
              cartFieldName: FieldValue.arrayUnion([productId]),
            });
            Get.snackbar('Ok', "Them vao cart ok");
          } else {
            Get.snackbar('Error', "Product is already in cart");
            return;
          }
        }
      } else {
        print('Không tìm thấy ng dùng phù hợp.');
      }
      print('Đã thêm sản phẩm vào cart thành công.');
    } catch (e) {
      print('Lỗi khi thêm sản phẩm vào cart: $e');
    }
  }

  Future<bool> addOrRemoveProductToWishlist(ProductModel productModel) async {
    final usersCollection = _db.collection('Users');
    try {
      Get.put(ProductRepository());
      /*String currentUserId =
          await currentCloudUser.then((value) => value.userId);*/
      final snapshot = await usersCollection
          .where(
            userIdFieldName,
            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
          )
          .get();
      if (snapshot.docs.isNotEmpty) {
        var firstDocument = snapshot.docs[0];
        var documentId = firstDocument.id;
        if (productModel.id!.isNotEmpty) {
          bool isProductInWishlist =
              firstDocument[wishlistFieldName].contains(productModel.id);
          if (!isProductInWishlist) {
            await usersCollection.doc(documentId).update({
              wishlistFieldName: FieldValue.arrayUnion([productModel.id]),
            });
            print('Them vao wishlist ok**1');
            return true;
          } else {
            await usersCollection.doc(documentId).update({
              wishlistFieldName: FieldValue.arrayRemove([productModel.id]),
            });
            print('Xoa khoi wishlist ok**1');
            return true;
          }
        } else {
          String? productId = await ProductRepository.instance
              .getDocumentIdForProduct(productModel);
          bool isProductInWishlist =
              firstDocument[wishlistFieldName].contains(productId);
          if (!isProductInWishlist) {
            await usersCollection.doc(documentId).update({
              wishlistFieldName: FieldValue.arrayUnion([productId]),
            });
            print('Them vao wishlist2 ok**2');
            return true;
          } else {
            await usersCollection.doc(documentId).update({
              wishlistFieldName: FieldValue.arrayRemove([productId]),
            });
            print('Xoa khoi wishlist ok**2');
            return true;
          }
        }
      } else {
        print('Không tìm thấy ng dùng phù hợp.');
        return false;
      }
    } catch (e) {
      e.printError();
      return false;
    }
  }
}
