import 'package:ecommerce_app_mobile/common/widgets/loading/custom_loading.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/cart/shop_and_pro_widget.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/cart_controller/cart_controller.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListShop extends StatelessWidget {
  const ListShop({super.key, this.showAddRemoveButton = true});

  final bool showAddRemoveButton;
  @override
  Widget build(BuildContext context) {
    // int hexColor(String color) {
    //   String newColor = '0xff$color';
    //   return int.parse(newColor);
    // }
    Get.put(CartController());
    return FutureBuilder(
        future: CartController.instance.getCartList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (CartController.instance.listShop.isEmpty) {
              return const Center(
                child: Text(
                  "Your cart is empty",
                  style: TextStyle(fontSize: 24),
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Obx(() => ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: CartController.instance.numberOfShop.value,
                        itemBuilder: (context, index) {
                          return ShopAndProduct(
                              shopModel:
                                  CartController.instance.listShop[index],
                              listProductOneShop:
                                  CartController.instance.listProduct[index],
                              listVariantInOneShop:
                                  CartController.instance.listVariant[index],
                              indexInCart: index,
                              listQuantityOneShop:
                                  CartController.instance.listQuantity[index]);
                        },
                      )),
                ),
              );
            }
          } else {
            return const Center(child: CustomLoading());
          }
        });
  }
}

Color getColorFromHex(String hexColor) {
  try {
    // Loại bỏ ký tự '#', nếu có
    hexColor = hexColor.replaceAll("#", "");

    // Kiểm tra xem chuỗi có đúng định dạng HEX không
    if (hexColor.length == 6 || hexColor.length == 8) {
      // Nếu đúng định dạng, chuyển đổi sang đối tượng Color và trả về
      return Color(int.parse("0xFF$hexColor"));
    } else {
      // Nếu không đúng định dạng, trả về màu mặc định hoặc giá trị null
      return Colors.grey; // Hoặc bạn có thể chọn màu khác tùy ý
    }
  } catch (e) {
    // Xử lý ngoại lệ nếu có lỗi trong quá trình chuyển đổi
    print("Error converting HEX to Color: $e");
    return Colors.grey; // Hoặc bạn có thể chọn màu khác tùy ý
  }
}
