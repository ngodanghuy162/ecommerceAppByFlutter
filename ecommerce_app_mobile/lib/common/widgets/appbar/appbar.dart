import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/device/device_utility.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TAppBar({
    super.key,
    this.title,
    this.showBackArrow = false,
    this.leadingIcon,
    this.leadingOnPress,
    this.actions,
    this.backOnPress,
    this.backgroundColor,
    this.isForceWhiteBackArrow,
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final void Function()? leadingOnPress;
  final void Function()? backOnPress;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool? isForceWhiteBackArrow;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      leading: showBackArrow
          ? IconButton(
              onPressed: backOnPress ?? () => Get.back(),
              icon: Icon(
                Iconsax.arrow_left,
                color: (isForceWhiteBackArrow != null && isForceWhiteBackArrow!)
                    ? TColors.light
                    : (THelperFunctions.isDarkMode(context)
                        ? TColors.light
                        : TColors.dark),
              ))
          : leadingIcon != null
              ? IconButton(
                  onPressed: () => leadingOnPress,
                  icon: Icon(
                    leadingIcon,
                    color: (THelperFunctions.isDarkMode(context)
                        ? TColors.light
                        : TColors.dark),
                  ))
              : null,
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
