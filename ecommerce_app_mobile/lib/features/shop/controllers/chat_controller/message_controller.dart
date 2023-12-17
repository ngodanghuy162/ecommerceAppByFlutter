import 'package:ecommerce_app_mobile/Service/Model/chat_model/message_model.dart';
import 'package:ecommerce_app_mobile/Service/Repository/chat_repository/message_repository.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  static MessageController get instance => Get.find();
  final _messageRepo = Get.put(MessageRepository());

  Stream<List<MessageModel>> getAllMessageByChatId(String chatId) {
    return _messageRepo.getAllMessageByChatId(chatId);
  }

  Future<void> sendMessage(MessageModel messageModel, String chatId) async {
    await _messageRepo.sendMessage(messageModel, chatId);
  }

}