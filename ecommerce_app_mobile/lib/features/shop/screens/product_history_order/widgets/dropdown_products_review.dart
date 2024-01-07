import 'package:flutter/material.dart';

class DropdownProductsReview extends StatefulWidget {
  final List<Map<String, String>> options;
  final ValueChanged<String> onChanged;
  final String initialValue;

  DropdownProductsReview(
      {required this.options,
      required this.onChanged,
      required this.initialValue});

  @override
  _DropdownProductsReviewState createState() => _DropdownProductsReviewState();
}

class _DropdownProductsReviewState extends State<DropdownProductsReview> {
  String? _selectedOptionKey;

  @override
  Widget build(BuildContext context) {
    _selectedOptionKey = widget.initialValue;
    return DropdownButtonFormField<String>(
      value: _selectedOptionKey,
      onChanged: (String? newValue) {
        setState(() {
          _selectedOptionKey = newValue;
          widget.onChanged(newValue!);
        });
      },
      items: widget.options.map((Map<String, String> option) {
        return DropdownMenuItem(
          value: option['key'],
          child: Text(option['value']!),
        );
      }).toList(),
    );
  }
}
