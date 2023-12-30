import 'package:ecommerce_app_mobile/Service/Model/chat_model/chat_model.dart';
import 'package:ecommerce_app_mobile/Service/Repository/chat_repository/chat_repository.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  static ChatController get instance => Get.find();
  final _chatRepo = Get.put(ChatRepository());

  Future<String> createNewChat(ChatModel chatModel) {
    return _chatRepo.createNewChat(chatModel);
  }

  Future<String?> getChatIfExist(String userEmail, String shopEmail) {
    return _chatRepo.getChatIfExist(userEmail, shopEmail);
  }

  Future<List<ChatModel>> getAllChatModelByShopEmail(String shopEmail) async {
    return _chatRepo.getAllChatModelByShopEmail(shopEmail);
  }
}
