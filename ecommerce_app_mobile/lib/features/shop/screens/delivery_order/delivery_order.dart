import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class DeliveryOrderPage extends StatefulWidget {
  const DeliveryOrderPage({super.key});

  @override
  State<DeliveryOrderPage> createState() => _DeliveryOrderPageState();
}

class _DeliveryOrderPageState extends State<DeliveryOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text("Delivery Order", style: TextStyle(color: Colors.black)),
        backgroundColor: TColors.primary,
      ),
      body: ContainedTabBarView(
        tabBarProperties: TabBarProperties(
          labelColor: Colors.deepOrange,
          indicatorColor: Colors.deepOrange,
          height: MediaQuery.of(context).size.height * 0.06,
          labelStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
        tabs: const [
          Text("Confirmation", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text("Delivering", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text("Completed", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text("Cancelled", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
        views: [
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Text("Confirm Page"),
          ),
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Text("Delivering Page"),
          ),
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Text("Complete Page"),
          ),
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Text("Cancelled Page"),
          ),
        ],
      ),
    );
  }
}
