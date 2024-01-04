import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/features/personalization/controllers/address_controller.dart';
import 'package:ecommerce_app_mobile/features/personalization/screens/address/edit_address.dart';
import 'package:ecommerce_app_mobile/features/personalization/screens/address/new_address.dart';
import 'package:ecommerce_app_mobile/features/personalization/screens/address/widgets/single_address.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.to(() => const NewAddressScreen()),
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
          () => Padding(
            padding: const EdgeInsets.only(
              top: TSizes.defaultSpace,
              right: TSizes.defaultSpace,
              left: TSizes.defaultSpace,
            ),
            child: ListView.separated(
                itemBuilder: (ctx, index) => GestureDetector(
                      onTap: () async {
                        SmartDialog.showLoading();
                        await controller.setDefaultAddress(
                            controller.listUserAddress[index]['id']);
                        SmartDialog.dismiss();
                      },
                      child: Slidable(
                        key: ValueKey(controller.listUserAddress[index]),
                        endActionPane: ActionPane(
                          dismissible: DismissiblePane(
                            onDismissed: () {
                              controller.removeUserAddress(
                                  controller.listUserAddress[index]['id'],
                                  context);
                            },
                          ),
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                controller.removeUserAddress(
                                    controller.listUserAddress[index]['id'],
                                    context);
                              },
                              icon: Iconsax.trash,
                              backgroundColor:
                                  Colors.redAccent.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(
                                TSizes.cardRadiusLg,
                              ),
                            )
                          ],
                        ),
                        startActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                Get.to(() =>
                                    EditAddressScreen(addressIndex: index));
                              },
                              icon: Iconsax.setting,
                              backgroundColor:
                                  Colors.blueAccent.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(
                                TSizes.cardRadiusLg,
                              ),
                            )
                          ],
                        ),
                        child: TSingleAddress(
                            optional: controller.listUserAddress[index]
                                ['optional'],
                            id: controller.listUserAddress[index]['id'],
                            isSelectedAddress: controller.listUserAddress[index]
                                ['isDefault'],
                            province: controller.listUserAddress[index]
                                ['province'],
                            district: controller.listUserAddress[index]
                                ['district'],
                            name: controller.listUserAddress[index]['name'],
                            phoneNumber: controller.listUserAddress[index]
                                ['phoneNumber'],
                            street: controller.listUserAddress[index]['street'],
                            ward: controller.listUserAddress[index]['ward']),
                      ),
                    ),
                separatorBuilder: (ctx, index) =>
                    const SizedBox(height: TSizes.spaceBtwItems),
                itemCount: controller.listUserAddress.length),
          ),
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
