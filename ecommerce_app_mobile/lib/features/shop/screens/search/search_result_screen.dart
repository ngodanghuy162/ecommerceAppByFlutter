import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/search_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/layout/grid_layout.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_controller.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SearchResultScreen extends StatelessWidget {
  final String keySearch;
  const SearchResultScreen({super.key, required this.keySearch});

  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Result'),
      ),
      body: Column(
        children: [
          Text("KeySearch la:$keySearch"),
          const TSearchContainer(text: "Testtt TSEARCH TEXT"),

          /// Drop down
          DropdownButtonFormField(
            decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
            onChanged: (value) {},
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
              future: productController.getAllProductByName(keySearch),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    // return TGridLayout(
                    //     itemCount: snapshot.data!.length,
                    //     itemBuilder: (_, index) => TProductCardVertical(
                    //           product: snapshot.data![index],
                    //         )); //TODO query and add
                    return Container();
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    return const Center(child: Text("smt went wrong"));
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              })
        ],
      ),
    );
  }
}
