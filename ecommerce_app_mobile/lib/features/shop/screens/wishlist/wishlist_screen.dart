import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_app_mobile/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app_mobile/common/widgets/loading/custom_loading.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/wishlist/wishlist_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/detail_product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/cart/cart.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:iconsax/iconsax.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    Get.put(WishlistController());
    print("Hello");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
// Hàm chuyển đổi chuỗi HEX sang đối tượng màu
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: false,
        title:
            Text("Wishlist", style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          TCircularIcon(
            icon: Iconsax.shopping_bag,
            onPressed: () => Get.to(CartScreen()),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: FutureBuilder(
            future: WishlistController.instance.getWishlist(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  if (WishlistController.instance.listProduct.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: THelperFunctions.screenHeight() / 2 -
                              TSizes.appBarHeight,
                        ), // Adjus,t the height as needed
                        const Center(
                          child: Center(
                            child: Center(
                              child: Text(
                                "Your wishlist is empty",
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(TSizes.defaultSpace),
                      child: Column(
                        children: [
                          TGridLayout(
                            itemCount: WishlistController
                                .instance.listProductSize.value,
                            itemBuilder: (_, index) {
                              ProductModel product = WishlistController
                                  .instance.listProduct[index];
                              // o day lay listVariantInCart thi no se van hien thi dung so san pham, nhung thuc te la no co rat nhieu san pham roi va bi lap moi lan vao lai cảt.
                              List<ProductVariantModel> listVariant =
                                  WishlistController.instance.listVariant[
                                      index]; // lay list cart mới chuẩn
                              BrandModel brand =
                                  WishlistController.instance.listBrand[index];
                              return TProductCardVertical(
                                modelDetail: DetailProductModel(
                                  brand: brand,
                                  product: product,
                                  listVariants: listVariant,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    );
                  }
                } else {
                  return const Text("Snap shot has no data");
                }
              } else {
                return const Center(child: CustomLoading());
              }
            },
          ),
        ),
      ),
    );
  }
}
