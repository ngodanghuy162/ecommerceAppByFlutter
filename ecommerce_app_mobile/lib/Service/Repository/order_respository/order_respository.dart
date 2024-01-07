import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/order_model/order_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/order_respository/payment_repository.dart';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/shop_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/brand_repository.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_repository.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_variant_repository.dart';
import 'package:ecommerce_app_mobile/repository/shop_repository/shop_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  final paymentRepository = Get.put(PaymentRepository());
  final shopRepository = Get.put(ShopRepository());
  final productVariantRepository = Get.put(ProductVariantRepository());
  final productRepository = Get.put(ProductRepository());
  final brandRepository = Get.put(BrandRepository());

  final _db = FirebaseFirestore.instance;

  final RxList<dynamic> userOrderList = [].obs;

  @override
  void onReady() async {
    super.onReady();
    await updateUserOrderList();
  }

  Map getOrderHistoryBarInfo() {
    int confirmation = 0, delivering = 0, completed = 0, cancelled = 0;
    for (var element in userOrderList) {
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

  Future<void> updateUserOrderList() async {
    final userRepo = Get.put(UserRepository());
    do {
      await userRepo.updateUserDetails();
    } while (userRepo.currentUserModel == null);
    userOrderList.value =
        (await getOrdersByUserId(userRepo.currentUserModel!.id!));
  }

  Future<String> addOrderSuccess(OrderModel orderModel) async {
    var ref = await _db.collection('Order').add(orderModel.toMap()).catchError(
      (error, stacktrace) {
        () => SmartDialog.showNotify(
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

  Future<void> updateOrderDetails(String id, OrderModel orderModel) async {
    await _db
        .collection('Order')
        .doc(id)
        .update(orderModel.toMap())
        .whenComplete(() => SmartDialog.showNotify(
              msg: 'Set order status successfully!',
              notifyType: NotifyType.success,
              displayTime: const Duration(seconds: 1),
            ))
        .catchError((error, stacktrace) {
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

  Future<List<Map<String, dynamic>>> getOrdersByUserId(String userId) async {
    final snapshot =
        await _db.collection('Order').where('user_id', isEqualTo: userId).get();
    final orders =
        snapshot.docs.map((e) => OrderModel.fromSnapshot(e).toMap()).toList();
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
