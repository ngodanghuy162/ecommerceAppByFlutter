import 'dart:convert';

import 'package:ecommerce_app_mobile/Service/Model/address_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();
  final _userRepo = Get.put(UserRepository());
  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final address = TextEditingController();
  final province = TextEditingController();
  final district = TextEditingController();
  final ward = TextEditingController();
  final street = TextEditingController();

  String? provinceId;
  String? districtid;
  String? wardCode;

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
          districtId: districtid!,
          wardCode: wardCode!,
          provinceId: provinceId!),
    );
    await setDefaultAddress(addressId);
  }

  Future<List<Map<String, dynamic>>> getAllUserAddress() async {
    return await _userRepo.getAllUserAddress();
  }

  Future<Map<String, dynamic>> getDefaultAddress() async {
    return await _userRepo.getDefaultAddress();
  }

  Future<void> setDefaultAddress(addressId) async {
    await _userRepo.setDefaultAddress(addressId);
  }

  Future<List<Map<String, dynamic>>> getAllProvinceVN() async {
    try {
      var url = Uri.https(
          'online-gateway.ghn.vn', 'shiip/public-api/master-data/province');
      var response = await http.post(
        url,
        headers: {
          'token': '7dbb1c13-7e11-11ee-96dc-de6f804954c9',
        },
      );
      print('Response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch province');
      }
      // print('Response body: ${response.body}');
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> provinceList = responseBody['data'];

      return provinceList.map(
        (element) {
          final e = element as Map<String, dynamic>;
          return {
            'ProvinceName': e['ProvinceName'],
            'ProvinceID': e['ProvinceID'],
          };
        },
      ).toList();
    } finally {}
  }

  Future<List<Map<String, dynamic>>> getDistrictOfProvinceVN(
      String provinceID) async {
    try {
      var url = Uri.https(
          'online-gateway.ghn.vn',
          'shiip/public-api/master-data/district',
          {'province_id': '$provinceID'});
      var response = await http.get(
        url,
        headers: {
          'token': '7dbb1c13-7e11-11ee-96dc-de6f804954c9',
        },
      );
      print('Response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch district');
      }
      // print('Response body: ${response.body}');
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> districtList = responseBody['data'];
      print(districtList);

      return districtList.map(
        (element) {
          final e = element as Map<String, dynamic>;
          return {
            'DistrictName': e['DistrictName'],
            'DistrictID': e['DistrictID'],
          };
        },
      ).toList();
    } finally {}
  }

  Future<List<Map<String, dynamic>>> getWardOfDistrictOfVN(
      String districtID) async {
    try {
      var url = Uri.https('online-gateway.ghn.vn',
          'shiip/public-api/master-data/ward', {'district_id': '$districtID'});
      var response = await http.get(
        url,
        headers: {
          'token': '7dbb1c13-7e11-11ee-96dc-de6f804954c9',
        },
      );
      print('Response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch ward');
      }
      // print('Response body: ${response.body}');
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> wardList = responseBody['data'];
      print(wardList);

      return wardList.map(
        (element) {
          final e = element as Map<String, dynamic>;
          return {
            'WardName': e['WardName'],
            'WardCode': e['WardCode'],
          };
        },
      ).toList();
    } finally {}
  }
}
