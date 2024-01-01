import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/loading/custom_loading.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/shop_address_controller/shop_address_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/address/new_address.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/address/widgets/single_address.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ShopAddressScreen extends StatefulWidget {
  const ShopAddressScreen({Key? key}) : super(key: key);

  @override
  State<ShopAddressScreen> createState() => _ShopAddressScreenState();
}

class _ShopAddressScreenState extends State<ShopAddressScreen> {
  final controller = Get.put(ShopAddressController());
  void didPop() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.to(() => NewShopAddressScreen(
                didPop: didPop,
              )),
          // onPressed: () async {
          //   print(await controller.getAllUserAddress());
          // },
          backgroundColor: TColors.primary,
          child: const Icon(
            Iconsax.add,
            color: TColors.white,
          ),
        ),
        appBar: TAppBar(
          showBackArrow: true,
          title: Text(
            'Address',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        body: FutureBuilder(
          future: controller.getAllShopAddress(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final data = snapshot.data;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    children: [
                      ...data!
                          .map(
                            (e) => GestureDetector(
                              onTap: () async {
                                SmartDialog.showLoading();
                                await controller.setDefaultAddress(e['id']);
                                setState(() {});
                                SmartDialog.dismiss();
                              },
                              child: TSingleAddress(
                                  optional: e['optional'],
                                  id: e['id'],
                                  isSelectedAddress: e['isDefault'],
                                  province: e['province'],
                                  district: e['district'],
                                  name: e['name'],
                                  phoneNumber: e['phoneNumber'],
                                  street: e['street'],
                                  ward: e['ward']),
                            ),
                          )
                          .toList(),
                      const SizedBox(height: TSizes.spaceBtwSections * 2),
                    ],
                  ),
                );
              }
            }
            return const SizedBox(
              height: 65,
              child: Center(
                child: Center(child: CustomLoading()),
              ),
            );
          },
        )
        // body: const SingleChildScrollView(
        //   padding: EdgeInsets.all(TSizes.defaultSpace),
        //   child: Column(
        //     children: [
        //       TSingleAddress(isSelectedAddress: false),
        //       TSingleAddress(isSelectedAddress: true),
        //     ],
        //   ),
        // ),
        );
  }
}
