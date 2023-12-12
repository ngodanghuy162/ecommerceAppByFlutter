import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/brand_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  final productCollection = FirebaseFirestore.instance.collection('Product');

  final brandController = Get.put(BrandController());

  Future<ProductModel> createProduct({
    required String brand_id,
    required String description,
    int? discount,
    required String name,
    required String product_category_id,
    List<dynamic>? rating,
    required List<String> variants_path,
  }) async {
    try {
      final documentReference = await productCollection.add({
        'brand_id': brand_id,
        'description': description,
        'discount': discount,
        'name': name,
        'product_category_id': product_category_id,
        'rating': rating,
        'variants_path': variants_path
      });

      // Lấy ID của document vừa được thêm vào Firestore
      final documentId = documentReference.id;

      Get.snackbar(
        'Thành công',
        'Bạn đã tạo sản phẩm mới',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );

      // Tạo đối tượng ProductModel và trả về
      return ProductModel(
        id: documentId,
        brand_id: brand_id,
        description: description,
        discount: discount,
        name: name,
        product_category_id: product_category_id,
        rating: rating,
        variants_path: variants_path,
      );
    } catch (error, stacktrace) {
      Get.snackbar(
        'Lỗi',
        'Có gì đó không đúng, thử lại?',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );

      print('Lỗi khi tạo sản phẩm: $error');
      print(stacktrace);

      // Nếu có lỗi, bạn có thể trả về một giá trị mặc định hoặc throw exception tùy thuộc vào yêu cầu của bạn.
      throw error;
    }
  }

  Future<List<ProductModel>> queryAllProductsFiltedBrand(String brandId) async {
    final snapshot =
        await productCollection.where('brand_id', isEqualTo: brandId).get();
    final productData =
        snapshot.docs.map((e) => ProductModel.fromSnapShot(e)).toList();
    return productData;
  }

  Future<List<ProductModel>> queryAllProductByName(String keySearch) async {
    final snapshot = await productCollection
        .where('name', isGreaterThanOrEqualTo: keySearch)
        .where('name', isLessThan: keySearch + 'z')
        .get();
    log("key: $keySearch :::" + snapshot.toString());
    final productData =
        snapshot.docs.map((e) => ProductModel.fromSnapShot(e)).toList();
    return productData;
  }

  Future<String?> getDocumentIdForProduct(ProductModel productModel) async {
    try {
      // Sử dụng query để tìm document có các trường dữ liệu giống với productModel
      final querySnapshot = await productCollection
          .where('brand_id', isEqualTo: productModel.brand_id)
          .where('description', isEqualTo: productModel.description)
          .where('name', isEqualTo: productModel.name)
          .where('product_category_id',
              isEqualTo: productModel.product_category_id)
          .get();

      // Kiểm tra xem có document nào khớp hay không
      if (querySnapshot.docs.isNotEmpty) {
        // Lấy documentId của document đầu tiên (nếu có nhiều document khớp)
        final documentId = querySnapshot.docs.first.id;
        return documentId;
      } else {
        return null;
      }
    } catch (error) {
      print('Lỗi khi lấy documentId cho ProductModel: $error');
      return null;
    }
  }
}
