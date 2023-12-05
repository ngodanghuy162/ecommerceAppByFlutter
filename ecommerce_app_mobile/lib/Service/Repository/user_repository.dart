import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Auth/firebaseauth_provider.dart';
import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './user_model_field.dart';

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
    String? email =
        FirebaseAuthProvider.firebaseAuthProvider.currentFirebaseUser!.email;
    String? phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;
    if (email != null) {
      final snapshot = await usersCollection
          .where(
            'email',
            isEqualTo: email,
          )
          .get();

      final userData =
          snapshot.docs.map((e) => CloudUserModel.fromSnapshot(e)).single;
      return userData;
    } else {
      final snapshot = await usersCollection
          .where(
            phoneNumberFieldName,
            isEqualTo: phoneNumber,
          )
          .get();

      final userData =
          snapshot.docs.map((e) => CloudUserModel.fromSnapshot(e)).single;
      return userData;
    }
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
      final userData = CloudUserModel.fromSnapshot(snapshot.docs.first);
      return userData;
    } else {
      // Nếu không tìm thấy người dùng, trả về null
      return null;
    }
  }

  Future<CloudUserModel?> getCloudUserByPhoneNumber(String phoneNumber) async {
    final snapshot = await usersCollection
        .where(
          phoneNumberFieldName,
          isEqualTo: phoneNumber,
        )
        .get();

    if (snapshot.docs.isNotEmpty) {
      print("Tim thay user");
      // Nếu tìm thấy người dùng, trả về CloudUserModel
      final userData = CloudUserModel.fromSnapshot(snapshot.docs.first);
      print(userData);
      return userData;
    } else {
      print("Null user ko tim thay");
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

  Future<void> addProductToCart(ProductModel productModel) async {
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
