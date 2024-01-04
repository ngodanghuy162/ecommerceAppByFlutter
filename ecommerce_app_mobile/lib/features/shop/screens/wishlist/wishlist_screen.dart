import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/wishlist/ItemWishlist.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/wishlist/wishlist_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/navigation_menu.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' show log;

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    Get.put(WishlistController());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
// Hàm chuyển đổi chuỗi HEX sang đối tượng màu
    return FutureBuilder(
        future: WishlistController.instance.getWishlist(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print("done connection");
            if (snapshot.hasData) {
              // List<String>? listProductInWlid = snapshot.data as List<String>;
              if (WishlistController.instance.listProduct.isEmpty) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50.0), // Adjust the height as needed
                    Center(
                      child: Text(
                        "Empty Wishlist",
                        style: TextStyle(
                          fontSize: 20.0, // Adjust the font size as needed
                          fontWeight: FontWeight.bold,
                          fontFamily: '',
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Scaffold(
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(TSizes.defaultSpace),
                      child: Column(
                        children: [
                          const Text(
                            'Your Wishlist Screen',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Obx(() => ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: WishlistController
                                    .instance.listProductSize.value,
                                itemBuilder: (context, index) {
                                  ProductModel product = WishlistController
                                      .instance.listProduct[index];
                                  // o day lay listVariantInCart thi no se van hien thi dung so san pham, nhung thuc te la no co rat nhieu san pham roi va bi lap moi lan vao lai cảt.
                                  List<ProductVariantModel> listVariant =
                                      WishlistController.instance.listVariant[
                                          index]; // lay list cart mới chuẩn
                                  BrandModel brand = WishlistController
                                      .instance.listBrand[index];
                                  return Column(
                                    children: [
                                      TWishListItem(
                                        brand: brand,
                                        product: product,
                                        listVariants: listVariant,
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            await UserRepository.instance
                                                .removeProductFromWishlist(
                                                    product);
                                            WishlistController.instance
                                                .listProductSize.value--;
                                            WishlistController
                                                .instance.listProduct
                                                .remove(product);
                                          },
                                          icon:
                                              const Icon(Icons.delete_forever))
                                    ],
                                  );
                                },
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              }
            } else {
              return Text("Snap shot has no data");
            }
          } else {
            return Text("Waiting pls");
          }
        });
  }
}
