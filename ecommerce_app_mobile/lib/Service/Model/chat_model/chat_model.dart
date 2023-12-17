import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? id;
  String userEmail;
  String shopEmail;

  ChatModel({
    this.id,
    required this.userEmail,
    required this.shopEmail,
  });

  toJson() {
    return {
      'userEmail': userEmail,
      'shopEmail': shopEmail,
    };
  }

  factory ChatModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ChatModel(
      id: document.id,
      userEmail: data['userEmail'],
      shopEmail: data['shopEmail'],
    );
  }
}