import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/loading/custom_loading.dart';
import 'package:ecommerce_app_mobile/features/personalization/controllers/address_controller.dart';
import 'package:ecommerce_app_mobile/features/personalization/screens/address/new_address.dart';
import 'package:ecommerce_app_mobile/features/personalization/screens/address/widgets/single_address.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class UserAddressScreen extends StatefulWidget {
  const UserAddressScreen({Key? key}) : super(key: key);

  @override
  State<UserAddressScreen> createState() => _UserAddressScreenState();
}

class _UserAddressScreenState extends State<UserAddressScreen> {
  final controller = Get.put(AddressController());
  void didPop() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(controller.listUserAddress);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => NewAddressScreen(
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
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              ...controller.listUserAddress
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
        ),
      ),

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
