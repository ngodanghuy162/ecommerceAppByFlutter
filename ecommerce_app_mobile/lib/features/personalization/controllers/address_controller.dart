import 'package:ecommerce_app_mobile/Service/Model/address_model.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Service/Repository/user_repository.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();
  final _userRepo = Get.put(UserRepository());
  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final province = TextEditingController();
  final district = TextEditingController();
  final ward = TextEditingController();
  final street = TextEditingController();

  Future<void> addUserAddress() async {
    final addressId = const Uuid().v1();
    await _userRepo.addUserAddress(
      AddressModel(
        phoneNumber: phoneNumber.text,
        name: name.text,
        province: province.text,
        district: district.text,
        street: street.text,
        ward: ward.text,
        isDefault: false,
        id: addressId,
      ),
    );
    await setDefaultAddress(addressId);
  }

  Future<List<Map<String, dynamic>>> getAllUserAddress() async {
    return await _userRepo.getAllUserAddress();
  }

  Future<void> setDefaultAddress(addressId) async {
    await _userRepo.setDefaultAddress(addressId);
  }
}
