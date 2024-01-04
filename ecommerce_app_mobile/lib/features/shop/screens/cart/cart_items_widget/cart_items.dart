// import 'package:ecommerce_app_mobile/common/styles/product_in_cart.dart';
// import 'package:ecommerce_app_mobile/common/styles/product_price_text.dart';
// import 'package:ecommerce_app_mobile/common/widgets/products/cart/add_remove_button.dart';
// import 'package:ecommerce_app_mobile/common/widgets/products/cart/cart_item_by_huy.dart';
// import 'package:ecommerce_app_mobile/common/widgets/products/cart/t_cart_item.dart';
// import 'package:ecommerce_app_mobile/features/shop/controllers/cart_controller/cart_controller.dart';
// import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_controller.dart';
// import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
// import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
// import 'package:ecommerce_app_mobile/repository/product_repository/product_repository.dart';
// import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
// import 'package:colornames/colornames.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:get/get.dart';

// class TCartItems extends StatelessWidget {
//   const TCartItems({super.key, this.showAddRemoveButton = true});

//   final bool showAddRemoveButton;
//   @override
//   Widget build(BuildContext context) {
//     // int hexColor(String color) {
//     //   String newColor = '0xff$color';
//     //   return int.parse(newColor);
//     // }
//     Get.put(CartController());
//     CartController.instance.updateTotalAmount();
//     return FutureBuilder(
//         future: CartController.instance.getCartList(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             print("done connection");
//             if (snapshot.hasData) {
//               List<ProductVariantModel>? listCart =
//                   snapshot.data as List<ProductVariantModel>;
//               if (listCart.isEmpty) {
//                 return const Text("Empty Cart");
//               } else {
//                 return SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(TSizes.defaultSpace),
//                     child: ListView.builder(
//                       physics: const ClampingScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: listCart.length,
//                       itemBuilder: (context, index) {
//                         ProductModel product =
//                             CartController.instance.listProduct[index];
//                         // o day lay listVariantInCart thi no se van hien thi dung so san pham, nhung thuc te la no co rat nhieu san pham roi va bi lap moi lan vao lai cảt.
//                         ProductVariantModel productVariant =
//                             listCart[index]; // lay list cart mới chuẩn
//                         int num = CartController.instance.listQuantity[index];
//                         var color = getColorFromHex(listCart[index].color);

//                         return Column(
//                           children: [
//                             TCartItemByHuy(
//                               title: product.name,
//                               imgUrl: productVariant.imageURL,
//                               color: color,
//                               size: productVariant.size,
//                             ),
//                             if (showAddRemoveButton)
//                               const SizedBox(height: TSizes.spaceBtwItems),
//                             if (showAddRemoveButton)
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   const SizedBox(width: 70),
//                                   //TProductQuantityWithAddAndRemove(),
//                                   TProductInCart(
//                                     price: productVariant.price.toString(),
//                                     isShowQuantity: true,
//                                     quantity: num,
//                                     index: index,
//                                   ),
//                                 ],
//                               ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 );
//               }
//             } else {
//               return Text("Your cart is empty");
//             }
//           } else {
//             return Text("Waiting pls");
//           }
//         });
//   }
// }

// Color getColorFromHex(String hexColor) {
//   try {
//     // Loại bỏ ký tự '#', nếu có
//     hexColor = hexColor.replaceAll("#", "");

//     // Kiểm tra xem chuỗi có đúng định dạng HEX không
//     if (hexColor.length == 6 || hexColor.length == 8) {
//       // Nếu đúng định dạng, chuyển đổi sang đối tượng Color và trả về
//       return Color(int.parse("0xFF$hexColor"));
//     } else {
//       // Nếu không đúng định dạng, trả về màu mặc định hoặc giá trị null
//       return Colors.grey; // Hoặc bạn có thể chọn màu khác tùy ý
//     }
//   } catch (e) {
//     // Xử lý ngoại lệ nếu có lỗi trong quá trình chuyển đổi
//     print("Error converting HEX to Color: $e");
//     return Colors.grey; // Hoặc bạn có thể chọn màu khác tùy ý
//   }
// }