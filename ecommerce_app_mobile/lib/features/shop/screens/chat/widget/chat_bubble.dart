import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool checkUser;
  const ChatBubble({super.key, required this.message, required this.checkUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: checkUser ? Colors.blue : Colors.grey.shade300,
      ),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          color: checkUser ? TColors.white : TColors.black,
        ),
      ),
    );
  }
}
