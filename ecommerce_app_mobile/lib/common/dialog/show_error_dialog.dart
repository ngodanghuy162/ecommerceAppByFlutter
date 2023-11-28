import 'package:flutter/material.dart';
import 'genericDialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: context.toString(),
    content: text,
    optionsBuilder: () => {
      context.toString(): null,
    },
  );
}
