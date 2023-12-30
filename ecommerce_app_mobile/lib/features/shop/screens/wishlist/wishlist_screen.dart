import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_app_mobile/features/personalization/screens/address/address.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/cart_controller/cart_controller.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String hexColor = "00B225"; // Chuỗi HEX từ cơ sở dữ liệu
    Color color = getColorFromHex(hexColor);

// Hàm chuyển đổi chuỗi HEX sang đối tượng màu
    Get.put(CartController());
    return Scaffold(
        appBar: TAppBar(
          showBackArrow: false,
          title: Text("Wishlist",
              style: Theme.of(context).textTheme.headlineMedium),
          actions: [
            TCircularIcon(
              icon: Iconsax.add,
              onPressed: () => Get.to(const UserAddressScreen()),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children:
                  // TGridLayout(
                  //   itemCount: 4,
                  //   itemBuilder: (_, index) =>
                  //       TProductCardVertical(), //TODO - query and add
                  // )
                  // Container(
                  //   width: 50, // Đặt kích thước của hình tròn
                  //   height: 50,
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     color: getColorFromHex(
                  //         hexColor), // Màu từ chuỗi HEX trong cơ sở dữ liệu
                  //   ),
                  // ),
                  List.generate(
                CartController.instance.listVariantInCart
                    .length, // Thay "yourList" bằng danh sách thực tế của bạn
                (index) => Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.all(8), // Khoảng cách giữa các hình tròn
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: getColorFromHex(CartController
                        .instance
                        .listVariantInCart[index]
                        .color), // Màu từ chuỗi HEX trong cơ sở dữ liệu
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

Color getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll("#", ""); // Loại bỏ ký tự '#' nếu có
  return Color(int.parse("0xFF$hexColor"));
}
