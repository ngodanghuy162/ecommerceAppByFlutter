// ignore_for_file: must_be_immutable

import 'package:ecommerce_app_mobile/common/styles/product_in_cart.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/cart/cart_item_by_huy.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/cart_controller/cart_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/shop_model.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopAndProduct extends StatefulWidget {
  ShopAndProduct(
      {super.key,
      this.showAddRemoveButton = true,
      required this.shopModel,
      required this.listProductOneShop,
      required this.listVariantInOneShop,
      required this.indexInCart,
      required this.listQuantityOneShop});

  final int indexInCart;
  final ShopModel shopModel;
  final List<ProductModel> listProductOneShop;
  final List<int> listQuantityOneShop;
  List<ProductVariantModel> listVariantInOneShop;
  final bool showAddRemoveButton;

  @override
  State<ShopAndProduct> createState() => _ShopAndProductState();
}

class _ShopAndProductState extends State<ShopAndProduct> {
  late List<bool> listCheckBoxProduct;
  bool checkboxShop = false;

  @override
  void initState() {
    super.initState();
    listCheckBoxProduct =
        List.generate(widget.listProductOneShop.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CartController());
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
                value: checkboxShop,
                onChanged: (newValue) {
                  setState(() {
                    checkboxShop = newValue!;
                    if (checkboxShop) {
                      print('Đã tích');
                      CartController.instance
                          .addChoosenListClickShop(widget.indexInCart);
                      listCheckBoxProduct =
                          List.filled(listCheckBoxProduct.length, newValue);
                    } else {
                      print('Chưa tích');
                      CartController.instance
                          .deleteChoosenListClickShop(widget.indexInCart);
                      listCheckBoxProduct =
                          List.filled(listCheckBoxProduct.length, newValue);
                    }
                  });
                }),
            Text(widget.shopModel.name),
          ],
        ),
        Obx(() => SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: CartController
                      .instance.listSizeProductInShop[widget.indexInCart].value,
                  itemBuilder: (context, index) {
                    ProductModel product = widget.listProductOneShop[index];
                    // o day lay listVariantInCart thi no se van hien thi dung so san pham, nhung thuc te la no co rat nhieu san pham roi va bi lap moi lan vao lai cảt.
                    ProductVariantModel productVariant = widget
                        .listVariantInOneShop[index]; // lay list cart mới chuẩn
                    int num = widget.listQuantityOneShop[index];
                    var color = getColorFromHex(productVariant.color);
                    return Column(
                      children: [
                        TCartItemByHuy(
                            title: product.name,
                            imgUrl: productVariant.imageURL,
                            color: color,
                            size: productVariant.size,
                            indexInShop: index,
                            indexinCart: widget.indexInCart,
                            checkboxValue: listCheckBoxProduct[index],
                            onCheckboxChanged: (newValue) {
                              // Kiểm tra xem tất cả checkbox sản phẩm đã được tích hay chưa
                              setState(() {
                                listCheckBoxProduct[index] = newValue;
                                if (listCheckBoxProduct
                                    .every((value) => value)) {
                                  checkboxShop = true;
                                } else {
                                  checkboxShop = false;
                                }
                              });
                            }),
                        if (widget.showAddRemoveButton)
                          const SizedBox(height: TSizes.spaceBtwItems),
                        if (widget.showAddRemoveButton)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 70),
                              //TProductQuantityWithAddAndRemove(),
                              TProductInCart(
                                  price: productVariant.price.toString(),
                                  isShowQuantity: true,
                                  quantity: num,
                                  indexInShop: index,
                                  productModel: product,
                                  productVariantId: productVariant.id,
                                  indexInCart: widget.indexInCart),
                            ],
                          ),
                      ],
                    );
                  },
                ),
              ),
            )),
      ],
    );
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
