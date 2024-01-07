import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/chat_model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class ChatRepository extends GetxController {
  static ChatRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<String> createNewChat(ChatModel chatModel) async {
    var id = await _db
        .collection('Chat')
        .add(chatModel.toJson())
        .catchError((error, stacktrace) {
      () => SmartDialog.showNotify(
            msg: 'Something went wrong, try again?',
            notifyType: NotifyType.failure,
            displayTime: const Duration(seconds: 1),
          );
    });
    return id.id;
  }

  Future<String?> getChatIfExist(String userEmail, String shopEmail) async {
    final snapshot = await _db
        .collection('Chat')
        .where('userEmail', isEqualTo: userEmail)
        .where('shopEmail', isEqualTo: shopEmail)
        .get();

    return snapshot.docs.isNotEmpty ? snapshot.docs.first.id : null;
  }

  Future<List<ChatModel>> getAllChatModelByShopEmail(String shopEmail) async {
    final snapshot = await _db
        .collection('Chat')
        .where('shopEmail', isEqualTo: shopEmail)
        .get();
    final chatData =
        snapshot.docs.map((e) => ChatModel.fromSnapshot(e)).toList();
    return chatData;
  }
}
