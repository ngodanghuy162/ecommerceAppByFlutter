import 'package:ecommerce_app_mobile/Service/Model/product_review_model/product_review_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/product_review_repository/product_review_repository.dart';
import 'package:get/get.dart';

class ProductReviewController extends GetxController {
  static ProductReviewController get instance => Get.find();
  final _productReviewRepo = Get.put(ProductReviewRepository());

  createReview(ProductReviewModel productReviewModel, String productId) async {
    await _productReviewRepo.createReview(productReviewModel,
        productId: productId);
  }

  Future<List<ProductReviewModel>> getAllReview(String productId) async {
    return await _productReviewRepo.getAllReview(productId: productId);
  }
}
