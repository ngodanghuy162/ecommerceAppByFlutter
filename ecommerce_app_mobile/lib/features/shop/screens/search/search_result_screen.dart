import 'package:ecommerce_app_mobile/Controller/search_controller.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/search_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_controller.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
        title: const Text('Search Result Screen'),
      ),
      body: Obx(
        () => Column(
          children: [
            Text(
                "KeySearch la: ${SearchControllerX.instance.keySearchObs.value}"),
            TSearchContainer(
              text: "Testt TSEARCH TEXT",
            ),

            /// Drop down
            DropdownButtonFormField(
              decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
              onChanged: (value) {
                // Handle dropdown value change
              },
              items: [
                'Name',
                'Higher Price',
                'Lower Price',
                'Sale',
                'Newest',
                'Popularity'
              ]
                  .map((option) =>
                      DropdownMenuItem(value: option, child: Text(option)))
                  .toList(),
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),

            /// Product
            FutureBuilder(
              future: productController.getAllProductByName(
                  SearchControllerX.instance.keySearchObs.value),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    print(SearchControllerX.instance.keySearchObs.value);
                    return TGridLayout(
                      itemCount: snapshot.data!.length,
                      // itemBuilder: (_, index) => TProductCardVertical(
                      //   product: snapshot.data![index],
                      itemBuilder: (_, index) =>
                          Text(snapshot.data![index].name.toString()),
                      // ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    return const Center(child: Text("Something went wrong"));
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
