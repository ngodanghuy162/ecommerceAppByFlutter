import 'package:cloud_firestore/cloud_firestore.dart';

class ProductReviewModel {
  final String? id;
  final String userEmail;
  final double rating;
  final String content;
  final Timestamp date;

  ProductReviewModel({
    this.id,
    required this.userEmail,
    required this.rating,
    required this.content,
    required this.date,
  });

  toJson() {
    return {
      //'id': id,
      'userEmail': userEmail,
      'rating': rating,
      'date': date,
      'content': content,
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

  factory ProductReviewModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ProductReviewModel(
      id: document.id,
      userEmail: data['userEmail'],
      rating: data['rating'] * 1.0,
      date: data['date'],
      content: data['content'],
    );
  }
}
