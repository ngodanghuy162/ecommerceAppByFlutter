import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:get/get.dart';

class AddressRepository extends GetxController {
  Future<Map<String, dynamic>> shippingCostEstimate(
    String serviceId,
    String fromDistrictId,
    String toDistrictId,
    String toWardCode,
    List<Map> items,
  ) async {
    final body = jsonEncode({
      "service_id": int.parse(serviceId),
      "insurance_value": 0,
      "coupon": null,
      "from_district_id": int.parse(fromDistrictId),
      "to_district_id": int.parse(toDistrictId),
      "to_ward_code": toWardCode,
      "weight": 500,
      "items": [...items]
    });
    try {
      var url = Uri.https(
          'online-gateway.ghn.vn', 'shiip/public-api/v2/shipping-order/fee');
      var response = await http.post(url,
          headers: {
            'token': '7dbb1c13-7e11-11ee-96dc-de6f804954c9',
            "Content-Type": "application/json"
          },
          body: body);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch shipping cost');
      }
      // print('Response body: ${response.body}');
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      final dynamic cost = responseBody['data'];
      return cost;
    } finally {}
  }

  Future<List<dynamic>> getShippingServiceAvailable(
      String shopId, String fromDistrict, String toDistrict) async {
    final body = jsonEncode({
      "shop_id": int.parse(shopId),
      "from_district": int.parse(fromDistrict),
      "to_district": int.parse(toDistrict),
    });
    try {
      var url = Uri.https('online-gateway.ghn.vn',
          'shiip/public-api/v2/shipping-order/available-services');
      var response = await http.post(url,
          headers: {
            'token': '7dbb1c13-7e11-11ee-96dc-de6f804954c9',
            "Content-Type": "application/json"
          },
          body: body);
      if (response.statusCode != 200) {
        print(response.body);
        throw Exception('Failed to fetch shipping service id');
      }
      // print('Response body: ${response.body}');
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      final dynamic service = responseBody['data'];
      return service;
    } finally {}
  }
}
