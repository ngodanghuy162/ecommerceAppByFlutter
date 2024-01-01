import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

// ignore: must_be_immutable
class TSingleAddress extends StatelessWidget {
  const TSingleAddress({
    super.key,
    required this.isSelectedAddress,
    required this.province,
    required this.district,
    required this.name,
    required this.phoneNumber,
    required this.street,
    required this.ward,
    required this.id,
    this.optional,
  });

  final String id;
  final bool isSelectedAddress;
  final String province;
  final String district;
  final String ward;
  final String name;
  final String street;
  final String phoneNumber;
  final String? optional;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return TRoundedContainer(
      width: double.infinity,
      showBorder: true,
      padding: const EdgeInsets.all(TSizes.md),
      backgroundColor: isSelectedAddress
          ? TColors.primary.withOpacity(0.5)
          : Colors.transparent,
      borderColor: isSelectedAddress
          ? Colors.transparent
          : isDark
              ? TColors.darkGrey
              : TColors.grey,
      child: Stack(
        children: [
          Positioned(
            right: 5,
            top: 0,
            child: Icon(
              isSelectedAddress ? Iconsax.tick_circle5 : null,
              color: isDark ? TColors.light : TColors.dark.withOpacity(0.6),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: TSizes.sm / 2),
              Text(
                phoneNumber,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: TSizes.sm / 2),
              Text(
                optional == ''
                    ? '$street, $ward, $district, $province'
                    : '$optional, $street, $ward, $district, $province',
                softWrap: true,
              )
            ],
          )
        ],
      ),
    );
  }
}
