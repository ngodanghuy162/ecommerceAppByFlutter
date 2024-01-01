import 'package:ecommerce_app_mobile/features/shop/screens/address/widgets/custom_flutter_google_places.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/shop_address_controller/shop_address_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:google_maps_webservice/places.dart';
import 'package:uuid/uuid.dart';

// custom scaffold that handle search
// basically your widget need to extends [GooglePlacesAutocompleteWidget]
// and your state [GooglePla,,cesAutocompleteState]
class CustomSearch extends PlacesAutocompleteWidget {
  CustomSearch({Key? key})
      : super(
          key: key,
          apiKey: 'bn7OlF8CF3syL2gzOFztPdJVLtHBLlxzAQd2VcaE',
          sessionToken: const Uuid().v4(),
          language: 'vn',
          components: [Component(Component.country, 'vn')],
        );

  @override
  // ignore: library_private_types_in_public_api
  _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
}

class _CustomSearchScaffoldState extends PlacesAutocompleteState {
  final controller = Get.put(ShopAddressController());
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AppBar(
          title: AppBarPlacesAutoCompleteTextField(
            getCurrentLocation: controller.getCurrentLocation,
            textStyle: null,
            textDecoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
            cursorColor: null,
          ),
        ),
        PlacesAutocompleteResult(
          onTap: (p) async => await controller.displayPrediction(
              p, ScaffoldMessenger.of(context)),
          logo: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
          resultTextStyle: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
