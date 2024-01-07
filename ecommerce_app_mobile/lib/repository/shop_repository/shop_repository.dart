import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/address_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/common/constant/cloudFieldName/shop_field.dart';
import 'package:ecommerce_app_mobile/features/shop/models/shop_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class ShopRepository extends GetxController {
  // Static instance variable
  static ShopRepository get instance => Get.find();
  final userRepo = Get.put(UserRepository());
  ShopModel? currentShopModel;
  final _db = FirebaseFirestore.instance;
  final shopCollection = FirebaseFirestore.instance.collection("Shop");
  @override
  Future<void> onReady() async {
    super.onReady();
    await updateShopDetails();
  }

  Future<void> removeShopAddress(
      String id, BuildContext context, void Function() callback) async {
    final shopData = currentShopModel;
    var listAddress = shopData!.address!;
    final currentObj =
        listAddress.singleWhere((element) => element['id'] == id);
    final currentIndex = listAddress.indexOf(currentObj);
    if (currentObj['isDefault'] == true && listAddress.length > 1) {
      listAddress.remove(currentObj);
      listAddress.first['isDefault'] = true;
    } else {
      listAddress.remove(currentObj);
    }
    shopData.address = listAddress;
    await _db
        .collection('Shop')
        .doc(shopData.id)
        .update(shopData.toMap())
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
              shopData.address = listAddress;
              await _db
                  .collection('Shop')
                  .doc(shopData.id)
                  .update(shopData.toMap())
                  .whenComplete(() async {
                await updateShopDetails();
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
      await updateShopDetails();
    }).catchError((error, stacktrace) {
      () => SmartDialog.showNotify(
            msg: 'Something went wrong, try again?',
            notifyType: NotifyType.failure,
            displayTime: const Duration(seconds: 1),
          );
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  Future<void> updateShopDetails() async {
    currentShopModel = await getShopDetails();
  }

  Future<ShopModel?> getShopDetails() async {
    do {
      await userRepo.updateUserDetails();
    } while (userRepo.currentUserModel == null);
    final snapshot = await _db
        .collection('Shop')
        .where(
          ownerField,
          isEqualTo: userRepo.currentUserModel!.email,
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
    if (snapshot.docs.map((e) => ShopModel.fromSnapshot(e)).isEmpty) {
      return null;
    }

    final shopData = snapshot.docs.map((e) => ShopModel.fromSnapshot(e)).single;
    return shopData;
  }

  List<Map<String, dynamic>> getAllShopAddress() {
    final shopDetail = currentShopModel;

    return shopDetail!.address!;
  }

  Future<void> updateAddressInfo(
      AddressModel currentAddressModel, index) async {
    final shopData = currentShopModel;

    shopData!.address![index] = currentAddressModel.toMap();
    await _db
        .collection('Shop')
        .doc(shopData.id)
        .update(shopData.toMap())
        .whenComplete(() {
      SmartDialog.showNotify(
        msg: 'Information changed successfully',
        notifyType: NotifyType.success,
        displayTime: const Duration(seconds: 1),
      );
      currentShopModel = shopData;
    }).catchError((error, stacktrace) {
      () => SmartDialog.showNotify(
            msg: 'Something went wrong, try again?',
            notifyType: NotifyType.failure,
            displayTime: const Duration(seconds: 1),
          );
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  Future<void> setDefaultAddress(String addressId) async {
    final shopData = currentShopModel;
    final listAddress = shopData!.address!.map(
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
    shopData.address = listAddress;
    await _db
        .collection('Shop')
        .doc(shopData.id)
        .update(shopData.toMap())
        .whenComplete(() {
      SmartDialog.showNotify(
        msg: 'Default address set successfully',
        notifyType: NotifyType.success,
        displayTime: const Duration(seconds: 1),
      );
      currentShopModel = shopData;
    }).catchError((error, stacktrace) {
      () => SmartDialog.showNotify(
            msg: 'Something went wrong, try again?',
            notifyType: NotifyType.failure,
            displayTime: const Duration(seconds: 1),
          );
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  Map<String, dynamic> getDefaultAddress() {
    final userData = currentShopModel;
    return userData!.address!
        .singleWhere((element) => element['isDefault'] == true);
  }

  Future<void> addShopAddress(AddressModel addressModel) async {
    final shopData = currentShopModel;
    shopData!.address!.add(addressModel.toMap());
    await _db
        .collection('Shop')
        .doc(shopData.id)
        .update(shopData.toMap())
        .whenComplete(() {
      SmartDialog.showNotify(
        msg: 'Address added successfully',
        notifyType: NotifyType.success,
        displayTime: const Duration(seconds: 1),
      );
      currentShopModel = shopData;
    }).catchError((error, stacktrace) {
      () => SmartDialog.showNotify(
            msg: 'Something went wrong, try again?',
            notifyType: NotifyType.success,
            displayTime: const Duration(seconds: 1),
          );
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  Future<void> addVoucher(String voucher) async {
    try {
      String? shopId = currentShopModel!.id;
      await shopCollection
          .doc(shopId)
          .update({voucherField: FieldValue.arrayUnion(voucher as List)});
    } catch (e) {
      e.printError();
    }
  }

  Future<void> addProduct(String productId) async {
    try {
      String? shopId = currentShopModel!.id;
      await shopCollection
          .doc(shopId)
          .update({productField: FieldValue.arrayUnion(productId as List)});
    } catch (e) {
      e.printError();
    }
  }

  Future<String> createShop(ShopModel shopModel) async {
    try {
      if (await UserRepository.instance.isSeller()) {
        return "";
      }
      DocumentReference documentReference =
          await shopCollection.add(shopModel.toMap());
      await UserRepository.instance.registerSellUser();
      return documentReference.id;
    } catch (e) {
      e.printError();
      throw Exception('Failed to create shop');
    }
  }

  //  Future<ShopModel> getShopByProduct(ProductModel product) async{
  //     try {
  //         shopCollection.where(
  //           "product"
  //         )
  //     }
  //  }

  Future<ShopModel> getShopByEmail(String email) async {
    try {
      final snapshot =
          await shopCollection.where("owner", isEqualTo: email).get();

      if (snapshot.docs.isNotEmpty) {
        // Assuming ShopModel has a named constructor that takes a Map<String, dynamic>
        return ShopModel.fromSnapshot(snapshot.docs.first);
      } else {
        throw Exception('Shop not found for email: $email');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to retrieve shop');
    }
  }

  Future<ShopModel> getShopByName(String name) async {
    try {
      final snapshot =
          await shopCollection.where("owner", isEqualTo: name).get();

      if (snapshot.docs.isNotEmpty) {
        // Assuming ShopModel has a named constructor that takes a Map<String, dynamic>
        return ShopModel.fromSnapshot(
            snapshot.docs.first.data() as DocumentSnapshot<Object?>);
      } else {
        throw Exception('Shop not found for email: $name');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to retrieve shop');
    }
  }
}
