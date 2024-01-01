import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/address_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/common/constant/cloudFieldName/shop_field.dart';
import 'package:ecommerce_app_mobile/features/shop/models/shop_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopRepository extends GetxController {
  // Static instance variable
  static ShopRepository get instance => Get.find();
  final userRepo = Get.put(UserRepository());
  late ShopModel currentShopModel;
  final _db = FirebaseFirestore.instance;

  @override
  Future<void> onReady() async {
    super.onReady();
    await updateShopDetails();
  }

  Future<void> updateShopDetails() async {
    currentShopModel = await getShopDetails();
  }

  Future<ShopModel> getShopDetails() async {
    final snapshot = await _db
        .collection('Shop')
        .where(
          ownerField,
          isEqualTo: userRepo.currentUserModel.id,
        )
        .get()
        .catchError(
      (error) {
        if (kDebugMode) {
          print(error);
        }
      },
    );

    final shopData = snapshot.docs.map((e) => ShopModel.fromSnapshot(e)).single;
    return shopData;
  }

  Future<List<Map<String, dynamic>>> getAllShopAddress() async {
    final shopDetail = await getShopDetails();

    return shopDetail.address!;
  }

  Future<void> setDefaultAddress(String addressId) async {
    final shopData = currentShopModel;
    final listAddress = shopData.address!.map(
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
      Get.snackbar(
        "Thành công",
        "Đặt địa chỉ mặc định thành công",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        duration: const Duration(seconds: 1),
      );
      currentShopModel = shopData;
    }).catchError((error, stacktrace) {
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

  Future<Map<String, dynamic>> getDefaultAddress() async {
    final userData = currentShopModel;
    return userData.address!
        .singleWhere((element) => element['isDefault'] == true);
  }

  Future<void> addShopAddress(AddressModel addressModel) async {
    final shopData = currentShopModel;
    shopData.address!.add(addressModel.toMap());
    await _db
        .collection('Shop')
        .doc(shopData.id)
        .update(shopData.toMap())
        .whenComplete(() {
      Get.snackbar(
        "Thành công",
        "Địa chỉ đã được thêm thành công",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        duration: const Duration(seconds: 1),
      );
      currentShopModel = shopData;
    }).catchError((error, stacktrace) {
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

  final shopCollection = FirebaseFirestore.instance.collection("Shop");

  Future<void> addVoucher(String voucher) async {
    try {
      String? shopId = currentShopModel.id;
      await shopCollection
          .doc(shopId)
          .update({voucherField: FieldValue.arrayUnion(voucher as List)});
    } catch (e) {
      e.printError();
    }
  }

  Future<void> addProduct(String productId) async {
    try {
      String? shopId = currentShopModel.id;
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

      print("dong 79 ok");
      await UserRepository.instance.registerSellUser();
      print("dong 83 ok");
      return documentReference.id;
    } catch (e) {
      e.printError();
      print("Error create shop");
      throw Exception('Failed to create shop');
    }
  }
}
