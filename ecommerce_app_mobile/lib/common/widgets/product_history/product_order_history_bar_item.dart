import 'package:badges/badges.dart' as badges;
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProductOrderHistoryBarItem extends StatelessWidget {
  const ProductOrderHistoryBarItem({
    super.key,
    required this.color,
    required this.label,
    required this.icon,
    required this.badgeLabel,
    this.size = 60,
  });

  final Color color;
  final String label;
  final IconData icon;
  final int badgeLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      // color: Colors.orange,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            badges.Badge(
              badgeContent: Text(
                badgeLabel.toString(),
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: TColors.light,
                    ),
              ),
              position: badges.BadgePosition.topEnd(top: -12, end: -12),
              badgeStyle: badges.BadgeStyle(
                shape: badges.BadgeShape.circle,
                badgeColor: badgeLabel != 0 ? Colors.blue : TColors.darkGrey,
                borderRadius: BorderRadius.circular(4),
                elevation: 0,
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            const SizedBox(height: TSizes.sm),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
