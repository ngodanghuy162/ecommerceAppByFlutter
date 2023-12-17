import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TColorChoiceChip extends StatefulWidget {
  const TColorChoiceChip({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
  });

  final String text;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  State<TColorChoiceChip> createState() => _TColorChoiceChipState();
}

class _TColorChoiceChipState extends State<TColorChoiceChip> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ChoiceChip(
        label: const SizedBox(),
        selected: widget.selected,
        onSelected: widget.onSelected,
        labelStyle: TextStyle(color: widget.selected ? TColors.white : null),
        avatar: TCircularContainer(
          width: 50,
          height: 50,
          backgroundColor: Color(
            hexColor(widget.text),
          ),
        ),
        shape: const CircleBorder(),
        labelPadding: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        //selectedColor: Colors.green,
        backgroundColor: Color(hexColor(widget.text)),
      ),
    );
  }
}

int hexColor(String color) {
  String newColor = '0xff$color';
  return int.parse(newColor);
}
