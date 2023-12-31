import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:get/get.dart';

class AddressRepository extends GetxController {
  Future<Map<String, dynamic>> shippingCostEstimate() async {
    final body = jsonEncode({
      "service_id": 53321,
      "insurance_value": 500000,
      "coupon": null,
      "from_district_id": 1542,
      "to_district_id": 1444,
      "to_ward_code": "20314",
      "height": 15,
      "length": 15,
      "weight": 1000,
      "width": 15
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

  Future<List<dynamic>> getShippingServiceAvailable() async {
    final body = jsonEncode({
      "shop_id": 4683322,
      "from_district": 1542,
      "to_district": 1444,
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
