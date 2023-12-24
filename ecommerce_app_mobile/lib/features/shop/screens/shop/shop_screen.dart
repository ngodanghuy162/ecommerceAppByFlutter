import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/sell_product/sell_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyShopScreen extends StatelessWidget {
  const MyShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        backgroundColor: Colors.green,
        title: Text("Here is your shop"),
      ),
      body: Column(children: [
        TextButton(
            onPressed: () => Get.to(() => SellProductScreen()),
            child:const  Text("Add product to sell"))
      ]),
    );
  }
}
