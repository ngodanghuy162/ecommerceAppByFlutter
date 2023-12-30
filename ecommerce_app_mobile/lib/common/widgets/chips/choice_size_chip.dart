import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TSizeChoiceChip extends StatelessWidget {
  const TSizeChoiceChip({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
    required this.quantity,
    required this.isIndex,
  });

  final String text;
  final bool selected;
  final void Function(bool)? onSelected;
  final int? quantity;
  final bool isIndex;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: quantity != null
          ? ChoiceChip(
              label: Text(text),
              selected: quantity! > 0 && isIndex ? selected : false,
              onSelected: quantity! > 0 && isIndex ? onSelected : null,
              labelStyle: quantity! > 0 && isIndex
                  ? TextStyle(color: selected ? TColors.white : null)
                  : TextStyle(
                      color: const Color.fromARGB(45, 0, 0, 0).withAlpha(100)),
            )
          : ChoiceChip(
              label: Text(text),
              selected: selected,
              onSelected: onSelected,
              labelStyle: TextStyle(color: selected ? TColors.white : null)),
    );
  }
}
