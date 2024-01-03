import 'package:ecommerce_app_mobile/features/shop/controllers/shop_address_controller/shop_address_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/address/widgets/single_address.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class AddressList extends StatefulWidget {
  const AddressList({super.key, this.data, required this.setStateParent});

  final List<Map<String, dynamic>>? data;
  final void Function() setStateParent;

  @override
  State<AddressList> createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  final controller = Get.put(ShopAddressController());
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        children: [
          ...widget.data!
              .map(
                (e) => GestureDetector(
                  onTap: () async {
                    SmartDialog.showLoading();
                    await controller.setDefaultAddress(e['id']);
                    widget.setStateParent();
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
