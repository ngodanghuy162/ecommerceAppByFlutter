import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/chat_model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRepository extends GetxController {
  static ChatRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<String> createNewChat(ChatModel chatModel) async {
    var id = await _db.collection('Chat').add(chatModel.toJson()).catchError((error, stacktrace) {
      () => Get.snackbar('Lỗi', 'Có gì đó không đúng, thử lại?',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
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

    return snapshot.docs.isNotEmpty
        ? snapshot.docs.first.id
        : null;
  }
}
