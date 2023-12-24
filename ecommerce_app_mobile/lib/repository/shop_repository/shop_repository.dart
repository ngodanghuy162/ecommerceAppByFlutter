import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/common/constant/cloudFieldName/shop_field.dart';
import 'package:ecommerce_app_mobile/features/shop/models/shop_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopRepository {
  // Static instance variable
  static ShopRepository? _instance;

  ShopRepository._(); // Private constructor

  // Factory method to get the singleton instance
  static ShopRepository get instance {
    _instance ??= ShopRepository._();
    return _instance!;
  }

  final shopCollection = FirebaseFirestore.instance.collection("Shop");

  Future<String?> getMyShopId() async {
    String userId = await UserRepository.instance.getCurrentUserDocId();
    try {
      final snapshot =
          await shopCollection.where(ownerField, isEqualTo: userId).get();

      if (snapshot.docs.isNotEmpty) {
        String id = snapshot.docs[0].id;
        return id;
      } else {
        Get.snackbar(
          'Not Found',
          'Not Found Shop',
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
    }
    return null;
  }

  Future<void> addVoucher(String voucher) async {
    try {
      String? shopId = await getMyShopId();
      await shopCollection
          .doc(shopId)
          .update({voucherField: FieldValue.arrayUnion(voucher as List)});
    } catch (e) {
      e.printError();
    }
  }

  Future<void> addProduct(String productId) async {
    try {
      String? shopId = await getMyShopId();
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
