import 'package:ecommerce_app_mobile/Controller/search_controller.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/search_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/detail_product_model.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SearchResultScreen extends StatelessWidget {
  String keySearch;

  SearchResultScreen({super.key, required this.keySearch});
// Updated constructor to initialize keySearchObs with the value of keySearch
  // SearchResultScreen({Key? key, required this.keySearch}) : super(key: key) {
  //   keySearchObs.value = keySearch;
  // }
  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController());
    Get.put(SearchControllerX());
    SearchControllerX.instance.keySearchObs.value = keySearch;
    print("Search Rs day");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Result'),
      ),
      body: Obx(
        () => Column(
          children: [
            const TSearchContainer(
              text: "Test TSEARCH TEXT",
            ),
            const SizedBox(
              height: 20,
            ),

            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.sort),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: TSizes.defaultSpace, vertical: 25),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.blue),
                        gapPadding: 20),
                  ),
                  onChanged: (value) {
                    // Handle dropdown value change
                  },
                  items: [
                    'Name',
                    'Higher Price',
                    'Sale',
                    'Newest',
                  ]
                      .map((option) =>
                          DropdownMenuItem(value: option, child: Text(option)))
                      .toList(),
                )),

            /// Drop down

            const SizedBox(
              height: 10,
            ),

            /// Product
            Expanded(
              child: FutureBuilder(
                future: productController.getAllProductBySearching(
                    SearchControllerX.instance.keySearchObs.value),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<DetailProductModel> listDetailProduct =
                          snapshot.data!;
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(2),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 30, top: 30, left: 24, bottom: 24),
                          child: TGridLayout(
                            itemCount: listDetailProduct.length,
                            itemBuilder: (context, index) =>
                                TProductCardVertical(
                                    modelDetail: listDetailProduct[index]),
                            // ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else {
                      return const Center(child: Text("Something went wrong"));
                    }
                  } else {
                    return const SizedBox(
                      height: 0,
                      width: 0,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
