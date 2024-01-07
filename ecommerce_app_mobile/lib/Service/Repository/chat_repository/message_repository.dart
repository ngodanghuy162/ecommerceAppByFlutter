import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/chat_model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class MessageRepository extends GetxController {
  static MessageRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Stream<List<MessageModel>> getAllMessageByChatId(String chatId) async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      final messageCollectionRef =
          await _db.collection('Chat').doc(chatId).collection('Message');

      // Kiểm tra xem collection đã tồn tại hay chưa
      final isCollectionExists = await messageCollectionRef.snapshots().isEmpty;

      // Nếu collection không tồn tại, tạo mới nó
      if (isCollectionExists) {
        await messageCollectionRef.add({}); // Thêm collection trống
      }

      final snapshot = await messageCollectionRef.orderBy('time').get();

      final messageData =
          snapshot.docs.map((e) => MessageModel.fromSnapShot(e)).toList();
      yield messageData;
    }
  }

  Future<void> sendMessage(MessageModel messageModel, String chatId) async {
    await _db
        .collection('Chat')
        .doc(chatId)
        .collection('Message')
        .add(messageModel.toJson())
        .catchError((error, stacktrace) {
      () => SmartDialog.showNotify(
            msg: 'Something went wrong, try again?',
            notifyType: NotifyType.failure,
            displayTime: const Duration(seconds: 1),
          );
    });
  }
}
