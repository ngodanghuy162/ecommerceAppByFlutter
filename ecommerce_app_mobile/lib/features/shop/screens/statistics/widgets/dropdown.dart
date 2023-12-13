import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

const List<String> Items = <String>['Week', 'Month', 'Year'];

class DropDownMenu extends StatefulWidget {
  const DropDownMenu({super.key});

  @override
  State<DropDownMenu> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  String dropdownValue = Items.first;

  // List of items in our dropdown menu
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      borderRadius: const BorderRadius.all(
        Radius.circular(TSizes.borderRadiusMd),
      ),
      // Initial Value
      value: dropdownValue,

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: Items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              items,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
    );
  }
}
