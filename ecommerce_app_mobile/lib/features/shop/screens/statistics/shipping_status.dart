import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/statistics/widgets/productItems.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ShippingStatus extends StatelessWidget {
  const ShippingStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TAppBar(
        title: Text("Status"),
        showBackArrow: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(
          TSizes.defaultSpace,
        ),
        child: ProductItemsStatus(),
      ),
    );
  }
}
