import 'package:ecommerce_app_mobile/features/personalization/screens/profile/profile_screen.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TUserProfileTitle extends StatefulWidget {
  const TUserProfileTitle({
    super.key,
    required this.lastName,
    required this.firstName,
    required this.email,
    required this.profileUrl,
  });

  final String lastName;
  final String firstName;
  final String email;
  final String profileUrl;

  @override
  State<TUserProfileTitle> createState() => _TUserProfileTitleState();
}

class _TUserProfileTitleState extends State<TUserProfileTitle> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          widget.profileUrl,
        ),
        radius: 30,
      ),
      title: Text(
        '${widget.firstName} ${widget.lastName}',
        style: Theme.of(context).textTheme.headlineSmall!.apply(
              color: TColors.white,
            ),
      ),
      subtitle: Text(
        widget.email,
        style: Theme.of(context).textTheme.bodyMedium!.apply(
              color: TColors.white,
            ),
      ),
      trailing: IconButton(
        onPressed: () => Get.off(const ProfileScreen()),
        icon: const Icon(
          Iconsax.edit,
          color: TColors.white,
        ),
      ),
    );
  }
}
