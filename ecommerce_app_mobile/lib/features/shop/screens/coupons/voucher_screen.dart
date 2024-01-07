import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/coupons/widgets/voucher_list.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text("Vouchers", style: TextStyle(color: Colors.black)),
      ),
      body: ContainedTabBarView(
        tabBarProperties: TabBarProperties(
          labelColor: TColors.primary,
          indicatorColor: TColors.primary,
          height: MediaQuery.of(context).size.height * 0.06,
          labelStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
        initialIndex: 0,
        tabs: const [
          Text("All",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text("For all products",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text("Shop",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text("Brand",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
        views: [
          VoucherList(dark: dark),
          VoucherList(dark: dark),
          VoucherList(dark: dark),
          VoucherList(dark: dark),
        ],
      ),
    );
  }
}
