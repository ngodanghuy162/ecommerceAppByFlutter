import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? id;
  String emailFrom;
  String emailTo;
  Timestamp time;
  String content;

  MessageModel({
    this.id,
    required this.emailFrom,
    required this.emailTo,
    required this.time,
    required this.content,
  });

  toJson() {
    return {
      'emailFrom': emailFrom,
      'emailTo': emailTo,
      'time': time,
      'content': content,
    };
  }

  String get formattedDate {
    final diff = DateTime.now().difference(time.toDate());
    String result;
    if (diff.inMinutes < 60) {
      result = '${diff.inMinutes} phút';
    } else if (diff.inHours <= 24) {
      result = '${diff.inHours} giờ';
    } else if (diff.inDays < 7) {
      result = '${diff.inDays} ngày';
    } else if (diff.inDays < 365) {
      result = '${diff.inDays ~/ 7} tuần';
    } else {
      result = '${diff.inDays ~/ 365} năm';
    }
    return result;
  }

  factory MessageModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return MessageModel(
      id: document.id,
      emailFrom: data['emailFrom'],
      emailTo: data['emailTo'],
      time: data['time'],
      content: data['content']
    );
  }
}