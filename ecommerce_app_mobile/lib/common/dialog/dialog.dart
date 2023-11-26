import 'package:flutter/material.dart';

Future<void> showDialogOnScreen({
  required BuildContext context,
  required String title,
  required String description,
  VoidCallback? onOkPressed,
  bool showCancelButton =
      true, // Thêm biến mặc định và ẩn nút Cancel khi là false
}) async {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: <Widget>[
        if (showCancelButton) // Kiểm tra showCancelButton trước khi thêm nút Cancel
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'OK');
            onOkPressed?.call();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}


// Sử dụng hàm showDialogWidget như sau:
// showDialogWidget(
//   context: context,
//   title: 'Failed to register',
//   description: 'Email has been used',
//   onOkPressed: () {
//     Get.to(() => const VerifyEmailScreen());
//   },
// );
