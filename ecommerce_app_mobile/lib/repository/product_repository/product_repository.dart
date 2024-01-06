import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/product_review_model/product_review_model.dart';
import 'package:ecommerce_app_mobile/features/admin/screens/display_all_product.dart/widgets/product_variant.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/brand_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/detail_product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/brand_repository.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/product_variant_repository.dart';
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
    bool popular = false,
    required String shopEmail,
  }) async {
    try {
      final documentReference = await productCollection.add({
        'brand_id': brand_id,
        'description': description,
        'discount': discount,
        'name': name,
        'product_category_id': product_category_id,
        'rating': rating,
        'variants_path': variants_path,
        'popular': popular,
        'shopEmail': shopEmail
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
        shopEmail: shopEmail,
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
      rethrow;
    }
  }

  Future<List<ProductModel>> queryAllProductsFiltedBrand(String brandId) async {
    final snapshot =
        await productCollection.where('brand_id', isEqualTo: brandId).get();
    final productData =
        snapshot.docs.map((e) => ProductModel.fromSnapShot(e)).toList();
    return productData;
  }

//get product model by vảiant id
  Future<ProductModel?> getProductByVariantId(String variantId) async {
    final snapshot = await productCollection
        .where('variants_path', arrayContains: variantId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Nếu có ít nhất một tài liệu thỏa mãn điều kiện
      final productData = ProductModel.fromSnapShot(snapshot.docs.first);
      return productData;
    } else {
      // Nếu không có tài liệu nào thỏa mãn điều kiện
      return null;
    }
  }

// de tim kiem san pham
  Future<List<DetailProductModel>?> queryAllProductByName(
      String keySearch) async {
    List<DetailProductModel> rs = [];
    // String keySearchUpper = keySearch.toUpperCase();
    // String keySearchLower = keySearch.toLowerCase();
    final snapshot1 = await productCollection
        .where('name', isGreaterThanOrEqualTo: '${keySearch}')
        .where('name', isLessThanOrEqualTo: '${keySearch}z')
        .get();

    final productData =
        snapshot1.docs.map((e) => ProductModel.fromSnapShot(e)).toList();

    for (int i = 0; i < productData.length; i++) {
      List<ProductVariantModel> tmp = await ProductVariantRepository.instance
          .queryVariants(productData[i].variants_path);
      BrandModel tmp2 = await BrandRepository.instance
          .queryBrandById(productData[i].brand_id);
      rs.add(DetailProductModel(
          brand: tmp2, product: productData[i], listVariants: tmp));
    }
    print("Size rs: ${rs.length}");
    return rs;
  }

  Future<String?> getDocumentIdForProduct(ProductModel productModel) async {
    try {
      // Sử dụng query để tìm document có các trường dữ liệu giống với productModel
      final querySnapshot = await productCollection
          .where('description', isEqualTo: productModel.description)
          .where('name', isEqualTo: productModel.name)
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

  Future<List<ProductModel>> queryAllProducts() async {
    final snapshot = await productCollection.get();
    final productData =
        snapshot.docs.map((e) => ProductModel.fromSnapShot(e)).toList();
    return productData;
  }

  Future<List<ProductModel>> queryPopularProducts() async {
    final snapshot =
        await productCollection.where('popular', isEqualTo: true).get();
    final productData =
        snapshot.docs.map((e) => ProductModel.fromSnapShot(e)).toList();
    return productData;
  }

  Future<List<ProductModel>> queryProductByCategory(String categoryID) async {
    final snapshot = await productCollection
        .where('product_category_id', isEqualTo: categoryID)
        .get();
    final productData =
        snapshot.docs.map((e) => ProductModel.fromSnapShot(e)).toList();
    return productData;
  }

  Future<List<ProductReviewModel>> queryReviewByProductID(
      String productID) async {
    final snapshot =
        await productCollection.doc(productID).collection('Review').get();
    final productData =
        snapshot.docs.map((e) => ProductReviewModel.fromSnapShot(e)).toList();
    return productData;
  }

  Future<ProductModel> getProductById(String id) async {
    final snapshot = await productCollection.doc(id).get();
    final productModel = ProductModel.fromSnapShot(snapshot);
    return productModel;
  }
}
