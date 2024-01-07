import 'package:flutter/material.dart';

class DropdownMenuShopOrderStatus extends StatefulWidget {
  final ValueChanged<String> onChanged;

  final String? initialValue;

  const DropdownMenuShopOrderStatus(
      {required this.onChanged, super.key, this.initialValue});

  @override
  // ignore: library_private_types_in_public_api
  _DropdownMenuShopOrderStatusState createState() =>
      _DropdownMenuShopOrderStatusState();
}

class _DropdownMenuShopOrderStatusState
    extends State<DropdownMenuShopOrderStatus> {
  String? _selectedStatus;
  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialValue ?? 'confirmation';
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      // padding: const EdgeInsets.all(TSizes.sm),
      hint: const Text('Change the product status'),
      value: _selectedStatus,
      onChanged: (String? newValue) {
        setState(() {
          _selectedStatus = newValue!;
          widget.onChanged(newValue);
        });
      },
      items: const [
        DropdownMenuItem(
          value: "confirmation",
          child: Text("Confirmation"),
        ),
        DropdownMenuItem(
          value: "delivering",
          child: Text("Delivering"),
        ),
        DropdownMenuItem(
          value: "completed",
          child: Text("Completed"),
        ),
        DropdownMenuItem(
          value: "cancelled",
          child: Text("Cancelled"),
        ),
      ],
    );
  }
}
