import 'package:ecommerce_app_mobile/Service/repository/order_respository/order_respository.dart';
import 'package:ecommerce_app_mobile/features/shop/models/shop_model.dart';
import 'package:ecommerce_app_mobile/repository/shop_repository/shop_repository.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/order_model/order_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/order_respository/payment_repository.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/brand_repository.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_repository.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_variant_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'dart:developer';

class ShopController extends GetxController {
  static ShopController get instance => Get.find();

  Future<void> addProductToShop(String productId) async {
    return await ShopRepository.instance.addProduct(productId);
  }

  Future<void> addVoucher(String voucher) async {
    return await ShopRepository.instance.addVoucher(voucher);
  }

  Future<String> createShop(ShopModel shopModel) async {
    return await ShopRepository.instance.createShop(shopModel);
  }

  Future<ShopModel> findShopByEmail(String email) async {
    return await ShopRepository.instance.getShopByEmail(email);
  }

  Future<ShopModel> findShopByName(String name) async {
    return await ShopRepository.instance.getShopByName(name);
  }

  //Get order list
  final paymentRepository = Get.put(PaymentRepository());
  final shopRepository = Get.put(ShopRepository());
  final productVariantRepository = Get.put(ProductVariantRepository());
  final productRepository = Get.put(ProductRepository());
  final brandRepository = Get.put(BrandRepository());
  final orderRepository = Get.put(OrderRepository());

  final _db = FirebaseFirestore.instance;

  final RxList<dynamic> shopOrderList = [].obs;

  @override
  void onReady() async {
    super.onReady();
    await updateShopOrderList();
  }

  Future<void> setOrderStatus(String id, String status) async {
    var model = await orderRepository.getOrderDetails(id);
    model.status = status;
    await orderRepository.updateOrderDetails(id, model);
    await updateShopOrderList();
  }

  Map getOrderHistoryBarInfo() {
    int confirmation = 0, delivering = 0, completed = 0, cancelled = 0;
    for (var element in shopOrderList) {
      switch (element['status']) {
        case 'confirmation':
          ++confirmation;
          break;
        case 'delivering':
          ++delivering;
          break;
        case 'completed':
          ++completed;
          break;
        case 'cancelled':
          ++cancelled;
          break;
      }
    }
    return {
      'confirmation': confirmation,
      'delivering': delivering,
      'completed': completed,
      'cancelled': cancelled
    };
  }

  Future<void> updateShopOrderList() async {
    do {
      await shopRepository.updateShopDetails();
    } while (shopRepository.currentShopModel == null);
    shopOrderList.value =
        (await getOrdersByShopEmail(shopRepository.currentShopModel!.owner));
  }

  Future<String> addOrderSuccess(OrderModel orderModel) async {
    var ref = await _db.collection('Order').add(orderModel.toMap()).catchError(
      (error, stacktrace) {
        SmartDialog.showNotify(
          msg: 'Something went wrong, try again?',
          notifyType: NotifyType.failure,
          displayTime: const Duration(seconds: 1),
        );
      },
    );
    return ref.id;
  }

  Future<OrderModel> getOrderDetails(String id) async {
    final snapshot = await _db.collection('Order').doc(id).get();
    final orderDetails = OrderModel.fromSnapshot(snapshot);
    return orderDetails;
  }

  Future<List<Map<String, dynamic>>> getOrdersByShopEmail(
      String shopEmail) async {
    final snapshot = await _db
        .collection('Order')
        .where('shopEmail', isEqualTo: shopEmail)
        .get();
    final orders = snapshot.docs.map((e) {
      return {
        ...OrderModel.fromSnapshot(e).toMap(),
        'order_id': e.id,
      };
    }).toList();
    List<Map<String, dynamic>> result = [];
    for (var element in orders) {
      final paymentModel =
          await paymentRepository.getPaymentDetails(element['payment_id']);

      result.add({...paymentModel.toMap(), ...element});
    }
    return result;
  }

  Future<Map<String, dynamic>?> getShopAndProductsOrderInfo(
      Map shopAndProducts) async {
    ShopModel shopData =
        await shopRepository.getShopByEmail(shopAndProducts['shopEmail']);

    final productsKeys = shopAndProducts['package']!.keys.toList();

    final result = [];

    for (var element in productsKeys) {
      final ProductModel? productModel =
          await productRepository.getProductByVariantId(element);
      final ProductVariantModel productVariantModel =
          await productVariantRepository.getVariantById(element);
      final BrandModel brandModel =
          await brandRepository.getBrandById(productModel!.brand_id);

      result.add({
        'product': productModel,
        'productVariant': productVariantModel,
        'brand': brandModel,
        'quantity': shopAndProducts['package']![element],
      });
    }

    return {
      'shopModel': shopData,
      'products': result,
    };
  }
}
