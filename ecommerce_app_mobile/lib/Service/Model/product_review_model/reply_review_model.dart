import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyReviewModel {
  final String? id;
  final String shopEmail;
  final String content;
  final Timestamp date;
  final String reviewId;

  ReplyReviewModel({
    this.id,
    required this.shopEmail,
    required this.content,
    required this.date,
    required this.reviewId,
  });

  toJson() {
    return {
      'id': id,
      'shopEmail': shopEmail,
      'content': content,
      'date': date,
      'reviewId': reviewId,
    };
  }

  String get formattedDate {
    final diff = DateTime.now().difference(date.toDate());
    String result;
    if (diff.inMinutes < 60) {
      result = '${diff.inMinutes} phút';
    } else if (diff.inHours <= 24) {
      result = '${diff.inHours} giờ';
    } else if (diff.inDays < 7) {
      result = '${diff.inDays} ngày';
    } else if (diff.inDays < 365) {
      result = '${(diff.inDays ~/ 7)} tuần';
    } else {
      result = '${(diff.inDays ~/ 365)} năm';
    }
    return result;
  }

  factory ReplyReviewModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ReplyReviewModel(
      id: document.id,
      shopEmail: data['shopEmail'],
      content: data['content'],
      date: data['date'],
      reviewId: data['reviewId'],
    );
  }
}
