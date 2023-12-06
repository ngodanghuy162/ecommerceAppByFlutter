import 'package:flutter/material.dart';

class AnnotatedChart extends StatelessWidget {
  const AnnotatedChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text("Waiting"),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 12,
              width: 12,
              color: Colors.black,
            )
          ],
        ),
        Row(
          children: [
            const Text("In shipping"),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 12,
              width: 12,
              color: Colors.blue,
            )
          ],
        ),
        Row(
          children: [
            const Text("Success"),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 12,
              width: 12,
              color: Colors.green,
            )
          ],
        ),
      ],
    );
  }
}
