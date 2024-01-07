import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/address/address.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/chat/shop_reply_chatting_screen.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/coupons/shop/shop_create_voucher.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/sell_product/sell_product.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(TSizes.spaceBtwItems),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ElevatedButton(
              onPressed: () => Get.to(() => const SellProductScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Độ cong của góc nút
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 24.0),
              ),
              child: const Text(
                "Add product to sell",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.to(() => const ShopReplyChattingScreen()),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.blueAccent, // Màu nền của nút// Màu chữ trên nút
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Độ cong của góc nút
              ),
              padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 24.0), // Khoảng cách giữa chữ và viền nút
            ),
            child: const Text(
              "Reply Chatting",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.to(() => const ShopAddressScreen()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            ),
            child: const Text(
              "Add Shop address",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.to(() => ShopCreateVoucher()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            ),
            child: const Text(
              "Create Voucher",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ]),
      ),
    );
  }
}
