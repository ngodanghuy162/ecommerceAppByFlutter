import 'package:ecommerce_app_mobile/Service/Model/product_review_model/reply_review_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/product_review_repository/reply_review_repository.dart';
import 'package:get/get.dart';

class ReplyReviewController extends GetxController {
  static ReplyReviewController get instance => Get.find();
  final _replyReviewRepo = Get.put(ReplyReviewRepository());

  Future<void> createReplyReview(ReplyReviewModel replyReviewModel, String productId) async {
    await _replyReviewRepo.createReplyReview(replyReviewModel, productId);
  }

  Future<List<ReplyReviewModel>> getAllReplyReview(String productId) async {
    return await _replyReviewRepo.getAllReplyReview(productId: productId);
  }
}
