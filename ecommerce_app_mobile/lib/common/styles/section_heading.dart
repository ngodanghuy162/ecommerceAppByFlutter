import 'package:flutter/material.dart';

class TSectionHeading extends StatefulWidget {
  const TSectionHeading({
    super.key,
    this.textColor,
    this.showActionButton = true,
    required this.title,
    this.buttonTitle = 'View all',
    this.onPressed,
    this.isViewAll,
  });

  final Color? textColor;
  final bool showActionButton;
  final String title, buttonTitle;
  final void Function()? onPressed;
  final bool? isViewAll;

  @override
  State<TSectionHeading> createState() => _TSectionHeadingState();
}

class _TSectionHeadingState extends State<TSectionHeading> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(color: widget.textColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        if (widget.showActionButton)
          TextButton(
              onPressed: widget.onPressed, child: Text(widget.buttonTitle)),
      ],
    );
  }
}
