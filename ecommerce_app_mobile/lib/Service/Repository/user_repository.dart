import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/address_model.dart';
import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:ecommerce_app_mobile/features/personalization/controllers/profile_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/cart_controller/cart_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_repository.dart';
import 'package:ecommerce_app_mobile/repository/shop_repository/shop_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import '../../common/constant/cloudFieldName/user_model_field.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  UserModel? currentUserModel;
  final RxInt cartAmount = 0.obs;
  @override
  Future<void> onReady() async {
    super.onReady();
    Get.put(ProfileController());
    if (FirebaseAuth.instance.currentUser != null) {
      await updateUserDetails();
    }
  }

  final _db = FirebaseFirestore.instance;
  Future<void> updateUserDetails() async {
    currentUserModel =
        await getUserDetails(FirebaseAuth.instance.currentUser!.email!);

    cartAmount.value = currentUserModel!.cart!.fold(
        0,
        (previousValue, element) =>
            previousValue +
            ((element as Map)['listvariant'] as Map).keys.length);
  }

  Future<bool> isEmailExisted(String email) async {
    final snapshot = await _db
        .collection('Users')
        .where(
          'email',
          isEqualTo: email,
        )
        .get()
        .catchError(
      // ignore: body_might_complete_normally_catch_error
      (error) {
        if (kDebugMode) {
          print(error);
        }
      },
    );
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e));
    return userData.isNotEmpty;
  }

  Future<void> removeUserAddress(
      String id, BuildContext context, void Function() callback) async {
    final userData = currentUserModel;
    var listAddress = userData!.address!;
    final currentObj =
        listAddress.singleWhere((element) => element['id'] == id);
    final currentIndex = listAddress.indexOf(currentObj);
    if (currentObj['isDefault'] == true && listAddress.length > 1) {
      listAddress.remove(currentObj);
      listAddress.first['isDefault'] = true;
    } else {
      listAddress.remove(currentObj);
    }
    userData.address = listAddress;
    await _db
        .collection('Users')
        .doc(userData.id)
        .update(userData.toMap())
        .whenComplete(() async {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Successfully deleted'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              if (currentObj['isDefault']) {
                listAddress = listAddress
                    .map(
                      (e) => {...e, 'isDefault': false},
                    )
                    .toList();
              }

              listAddress.insert(currentIndex, currentObj);
              userData.address = listAddress;
              await _db
                  .collection('Users')
                  .doc(userData.id)
                  .update(userData.toMap())
                  .whenComplete(() async {
                await updateUserDetails();
                callback();
              }).catchError((error, stacktrace) {
                () => SmartDialog.showNotify(
                      msg: 'Failed to undo operation!',
                      notifyType: NotifyType.failure,
                      displayTime: const Duration(seconds: 1),
                    );
                if (kDebugMode) {
                  print(error.toString());
                }
              });
            },
          ),
        ),
      );

      await updateUserDetails();
    }).catchError((error, stacktrace) {
      () => SmartDialog.showNotify(
            msg: 'Failed to undo operation, try again!',
            notifyType: NotifyType.failure,
            displayTime: const Duration(seconds: 1),
          );
      if (kDebugMode) {
        print(error.toString());
      }
    });
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
      // ignore: body_might_complete_normally_catch_error
      (error) {
        if (kDebugMode) {
          print(error);
        }
      },
    );

    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    Get.put(ProfileController());
    //Get.put(CartController());
    ProfileController.instance.crtUser = userData;
    return userData;
  }

  Future<void> updatePassword(UserModel userModel) async {
    await FirebaseAuth.instance.currentUser!
        .updatePassword(userModel.password!);
  }

  List<Map<String, dynamic>> getAllUserAddress() {
    final userData = currentUserModel;
    return userData!.address!;
  }

  Future<void> setDefaultAddress(String addressId) async {
    final userData = currentUserModel;
    final listAddress = userData!.address!.map(
      (e) {
        final addressModel = AddressModel(
            id: e['id'],
            phoneNumber: e['phoneNumber'],
            name: e['name'],
            province: e['province'],
            district: e['district'],
            street: e['street'],
            ward: e['ward'],
            isDefault: false,
            districtId: e['districtId'],
            provinceId: e['provinceId'],
            wardCode: e['wardCode'],
            lat: e['lat'],
            lng: e['lng'],
            optional: e['optional']);

        if (addressModel.id == addressId) {
          addressModel.isDefault = true;
        }
        return addressModel.toMap();
      },
    ).toList();
    userData.address = listAddress;
    await _db
        .collection('Users')
        .doc(userData.id)
        .update(userData.toMap())
        .whenComplete(() {
      SmartDialog.showNotify(
        msg: 'Default address set successfully',
        notifyType: NotifyType.success,
        displayTime: const Duration(seconds: 1),
      );
      currentUserModel = userData;
    }).catchError((error, stacktrace) {
      () => SmartDialog.showNotify(
            msg: 'Failed to undo operation, try again!',
            notifyType: NotifyType.failure,
            displayTime: const Duration(seconds: 1),
          );
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  Future<void> updateAddressInfo(
      AddressModel currentAddressModel, index) async {
    final userData = currentUserModel;

    userData!.address![index] = currentAddressModel.toMap();
    await _db
        .collection('Users')
        .doc(userData.id)
        .update(userData.toMap())
        .whenComplete(() {
      SmartDialog.showNotify(
        msg: 'Information changed successfully',
        notifyType: NotifyType.success,
        displayTime: const Duration(seconds: 1),
      );
      currentUserModel = userData;
    }).catchError((error, stacktrace) {
      () => SmartDialog.showNotify(
            msg: 'Failed to undo operation, try again!',
            notifyType: NotifyType.failure,
            displayTime: const Duration(seconds: 1),
          );
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  Map<String, dynamic> getDefaultAddress() {
    final userData = currentUserModel;
    return userData!.address!
        .singleWhere((element) => element['isDefault'] == true);
  }

  Future<List<String>?> getUserWishlist() async {
    final userData =
        await getUserDetails(FirebaseAuth.instance.currentUser!.email!);
    return userData.wishlist;
  }

  Future<List<dynamic>?> getUserCart() async {
    final userData =
        await getUserDetails(FirebaseAuth.instance.currentUser!.email!);
    return userData.cart;
  }

  Future<void> addUserAddress(AddressModel addressModel) async {
    final userData = currentUserModel;
    userData!.address!.add(addressModel.toMap());
    await _db
        .collection('Users')
        .doc(userData.id)
        .update(userData.toMap())
        .whenComplete(() {
      SmartDialog.showNotify(
        msg: 'Address added successfully',
        notifyType: NotifyType.success,
        displayTime: const Duration(seconds: 1),
      );
      currentUserModel = userData;
    }).catchError((error, stacktrace) {
      () => SmartDialog.showNotify(
            msg: 'Failed to undo operation, try again!',
            notifyType: NotifyType.success,
            displayTime: const Duration(seconds: 1),
          );
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

//get user id (doc id cua user)
  Future<String> getCurrentUserDocId() async {
    String email = FirebaseAuth.instance.currentUser!.email!;
    try {
      final snapshot =
          await _db.collection("Users").where("email", isEqualTo: email).get();

      if (snapshot.docs.isNotEmpty) {
        String id = snapshot.docs[0].id;
        return id;
      } else {
        Get.snackbar(
          'Not Found User',
          'Not Found User',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red,
        );
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'An error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );

      if (kDebugMode) {
        print(error.toString());
      }
    }
    return "No";
  }

  //cap nhat neu nguoi ban dang ki ban hang
  Future<void> registerSellUser() async {
    try {
      String userId = await getCurrentUserDocId();
      await _db
          .collection("Users")
          .doc(userId)
          .update({isSellFieldName: true}).then(
        (value) => SmartDialog.showNotify(
          msg: 'You register to be shop successfully',
          notifyType: NotifyType.success,
          displayTime: const Duration(seconds: 1),
        ),
      );
    } catch (error) {
      SmartDialog.showNotify(
        msg: 'Failed to undo operation, try again!',
        notifyType: NotifyType.failure,
        displayTime: const Duration(seconds: 1),
      );

      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

  Future<void> updateUserDetail(UserModel userModel) async {
    await _db
        .collection('Users')
        .doc(userModel.id)
        .update(userModel.toMap())
        .whenComplete(() => SmartDialog.showNotify(
              msg: 'Update profile successfully',
              notifyType: NotifyType.success,
              displayTime: const Duration(seconds: 1),
            ))
        .catchError((error, stacktrace) {
      () => SmartDialog.showNotify(
            msg: 'Failed to undo operation, try again!',
            notifyType: NotifyType.failure,
            displayTime: const Duration(seconds: 1),
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

  Future<void> createUser(UserModel userModel) async {
    await _db
        .collection('Users')
        .add(userModel.toMap())
        .whenComplete(
          () => SmartDialog.showNotify(
            msg: 'Your account has been created',
            notifyType: NotifyType.success,
            displayTime: const Duration(seconds: 1),
          ),
        )
        // ignore: body_might_complete_normally_catch_error
        .catchError((error, stacktrace) async {
      await updateUserDetails();
      SmartDialog.showNotify(
        msg: 'Failed to undo operation, try again!',
        notifyType: NotifyType.failure,
        displayTime: const Duration(seconds: 1),
      );

      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  // kiem tra xem da dang ki ban hang cuha
  Future<bool> isSeller() async {
    final user =
        await getUserDetails(FirebaseAuth.instance.currentUser!.email!);
    return user.isSell;
  }

  Future<void> addProductToCart(
      int quantity, String productVariantId, ProductModel? productModel) async {
    Get.put(ShopRepository());
    try {
      if (ProfileController.instance.crtUser == null) {
        final currentUser =
            await getUserDetails(FirebaseAuth.instance.currentUser!.email!);
        ProfileController.instance.crtUser = currentUser;
      }
      final userData = currentUserModel;

      Map<String, int> productVariantMap = {productVariantId: quantity};
      // List<Map<String, dynamic>> productVariantList = productVariantMap.entries
      //     .map((entry) => {'${entry.key}': entry.value})
      //     .toList();
      var myCart =
          ProfileController.instance.crtUser!.cart ?? currentUserModel!.cart;
      // Expected a value of type 'List<dynamic>', but got one of type 'IdentityMap<String, int>
      final shop =
          await ShopRepository.instance.getShopByEmail(productModel!.shopEmail);
      int index =
          myCart?.indexWhere((item) => item['shopemail'] == shop.owner) ?? -1;
      if (index != -1) {
        final listVariant = myCart![index]["listvariant"];
        if (listVariant is Map<String, dynamic>) {
          // Kiểm tra xem có key "productVariantId" không
          if (listVariant.containsKey(productVariantId)) {
            listVariant[productVariantId] =
                listVariant[productVariantId] + quantity;
            myCart[index]["listvariant"] = listVariant;
            print('Updated value for "$productVariantId" in listVariant.');
          } else {
            listVariant[productVariantId] = quantity;
            myCart[index]["listvariant"] = listVariant;
            print('Đã thêm sản phẩm vào cart thành công dong 416 voi co shop.');
          }
        } else {
          print('listVariant is not a Map<String, dynamic>');
        }
      } else {
        Map<dynamic, dynamic> newCartItem = {
          'shopemail': shop.owner,
          'listvariant': productVariantMap,
        };
        myCart?.add(newCartItem);
        print(
            'Đã thêm sản phẩm vào cart thành công dong 422 voi chua co shop.');
      }
      userData!.cart = myCart;
      await updateUserDetails();
      await _db
          .collection('Users')
          .doc(ProfileController.instance.crtUser!.id)
          .update(userData!.toMap())
          .whenComplete(() => SmartDialog.showNotify(
                msg: 'Add product to cart successfully!',
                notifyType: NotifyType.success,
                displayTime: const Duration(seconds: 1),
              ))
          .catchError((error, stacktrace) {
        () => () => SmartDialog.showNotify(
              msg: 'Failed to undo operation, try again!',
              notifyType: NotifyType.failure,
              displayTime: const Duration(seconds: 1),
            );
        if (kDebugMode) {
          print(error.toString());
        }
      });
      return;
    } catch (e) {
      print('Lỗi khi thêm sản phẩm vào cart: $e');
    }
  }

  Future<bool> deleteProductFromCart(
      String productVariantId, ProductModel product) async {
    Get.put(ShopRepository());
    Get.put(CartController());
    bool isDeleteShop = false;
    try {
      if (ProfileController.instance.crtUser == null) {
        final currentUser =
            await getUserDetails(FirebaseAuth.instance.currentUser!.email!);
        ProfileController.instance.crtUser = currentUser;
      }
      final userData = currentUserModel;

      var myCart =
          ProfileController.instance.crtUser!.cart ?? currentUserModel!.cart;
      // Expected a value of type 'List<dynamic>', but got one of type 'IdentityMap<String, int>
      int index = myCart
              ?.indexWhere((item) => item['shopemail'] == product.shopEmail) ??
          -1;
      if (index != -1) {
        final listVariant = myCart![index]["listvariant"];
        if (listVariant is Map<String, dynamic>) {
          // Kiểm tra xem có key "productVariantId" không
          if (listVariant.containsKey(productVariantId)) {
            listVariant.remove(productVariantId);
            myCart[index]["listvariant"] = listVariant;
            if (listVariant.isEmpty) {
              myCart.removeAt(index);
              isDeleteShop = true;
            }
            CartController.instance.getCartList();
            print('Delete "$productVariantId" in cart.');
          }
        } else {
          print('listVariant is not a Map<String, dynamic>');
        }
      } else {
        return isDeleteShop;
      }

      userData!.cart = myCart;
      await _db
          .collection('Users')
          .doc(ProfileController.instance.crtUser!.id)
          .update(userData.toMap())
          .whenComplete(() => () => SmartDialog.showNotify(
                msg: 'Delete from cart successfully',
                notifyType: NotifyType.success,
                displayTime: const Duration(seconds: 1),
              ))
          .catchError((error, stacktrace) {
        () => () => SmartDialog.showNotify(
              msg: 'Failed to undo operation, try again!',
              notifyType: NotifyType.failure,
              displayTime: const Duration(seconds: 1),
            );
        if (kDebugMode) {
          print(error.toString());
        }
      });
      //    await CartController.instance.getCartList();
      return isDeleteShop;
    } catch (e) {
      print('Lỗi khi xoa san pham khoi cart: $e');
      return false;
    }
  }

  updateQuantityInCart(
      int quantity, String productVariantId, ProductModel? productModel) async {
    Get.put(ShopRepository());
    Get.put(CartController());
    try {
      if (ProfileController.instance.crtUser == null &&
          currentUserModel == null) {
        final currentUser =
            await getUserDetails(FirebaseAuth.instance.currentUser!.email!);
        ProfileController.instance.crtUser = currentUser;
      }
      final userData = currentUserModel;

      // List<Map<String, dynamic>> productVariantList = productVariantMap.entries
      //     .map((entry) => {'${entry.key}': entry.value})
      //     .toList();
      var myCart =
          ProfileController.instance.crtUser!.cart ?? currentUserModel!.cart;
      // Expected a value of type 'List<dynamic>', but got one of type 'IdentityMap<String, int>
      int index = myCart?.indexWhere(
              (item) => item['shopemail'] == productModel!.shopEmail) ??
          -1;
      if (index != -1) {
        final listVariant = myCart![index]["listvariant"];
        if (listVariant is Map<String, dynamic>) {
          // Kiểm tra xem có key "productVariantId" không
          if (listVariant.containsKey(productVariantId)) {
            listVariant[productVariantId] = quantity;
            myCart[index]["listvariant"] = listVariant;
            print('Updated quantity for "$productVariantId" in cart.');
          }
        } else {
          print('listVariant is not a Map<String, dynamic>');
        }
      } else {
        return;
      }
      userData!.cart = myCart;
      await _db
          .collection('Users')
          .doc(ProfileController.instance.crtUser!.id)
          .update(userData.toMap())
          .catchError((error, stacktrace) {
        () => Get.snackbar(
              'Failed',
              'Something went wrong, try again?',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent.withOpacity(0.1),
              colorText: Colors.red,
            );
        if (kDebugMode) {
          print(error.toString());
        }
      });
      //await CartController.instance.getCartList();
      return;
    } catch (e) {
      print('Lỗi khiupdate quantity in cart: $e');
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
            emailFieldName,
            isEqualTo: FirebaseAuth.instance.currentUser!.email,
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

  Future<void> removeProductFromWishlist(ProductModel productModel) async {
    final usersCollection = _db.collection('Users');
    try {
      Get.put(ProductRepository());
      /*String currentUserId =
          await currentCloudUser.then((value) => value.userId);*/
      final snapshot = await usersCollection
          .where(
            emailFieldName,
            isEqualTo: FirebaseAuth.instance.currentUser!.email,
          )
          .get();
      if (snapshot.docs.isNotEmpty) {
        var firstDocument = snapshot.docs[0];
        var documentId = firstDocument.id;
        if (productModel.id!.isNotEmpty) {
          bool isProductInWishlist =
              firstDocument[wishlistFieldName].contains(productModel.id);
          if (isProductInWishlist) {
            await usersCollection.doc(documentId).update({
              wishlistFieldName: FieldValue.arrayRemove([productModel.id]),
            });
          }
        } else {
          String? productId = await ProductRepository.instance
              .getDocumentIdForProduct(productModel);
          bool isProductInWishlist =
              firstDocument[wishlistFieldName].contains(productId);
          if (isProductInWishlist) {
            await usersCollection.doc(documentId).update({
              wishlistFieldName: FieldValue.arrayRemove([productId]),
            });
          }
        }
      } else {
        print('Không tìm thấy ng dùng phù hợp.');
      }
    } catch (e) {
      e.printError();
    }
  }

  Future<bool> isProductInWishList(ProductModel product) async {
    final usersCollection = _db.collection('Users');
    try {
      Get.put(ProductRepository());
      /*String currentUserId =
          await currentCloudUser.then((value) => value.userId);*/
      final snapshot = await usersCollection
          .where(
            emailFieldName,
            isEqualTo: FirebaseAuth.instance.currentUser!.email,
          )
          .get();
      if (snapshot.docs.isNotEmpty) {
        var firstDocument = snapshot.docs[0];
        //  var documentId = firstDocument.id;
        if (product.id!.isNotEmpty) {
          return firstDocument[wishlistFieldName].contains(product.id);
        } else {
          String? productId =
              await ProductRepository.instance.getDocumentIdForProduct(product);
          return firstDocument[wishlistFieldName].contains(productId);
        }
      } else {
        return false;
      }
    } catch (e) {
      e.printError();
      return false;
    }
  }
}
