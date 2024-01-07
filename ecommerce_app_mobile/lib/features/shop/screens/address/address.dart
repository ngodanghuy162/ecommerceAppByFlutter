import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/features/personalization/screens/address/widgets/single_address.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/shop_address_controller/shop_address_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/address/edit_address.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/address/new_address.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.to(() => const NewShopAddressScreen()),
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
                            controller.listShopAddress[index]['id']);
                        SmartDialog.dismiss();
                      },
                      child: Slidable(
                        key: ValueKey(controller.listShopAddress[index]),
                        endActionPane: ActionPane(
                          dismissible: DismissiblePane(
                            onDismissed: () {
                              controller.removeShopAddress(
                                  controller.listShopAddress[index]['id'],
                                  context);
                            },
                          ),
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                controller.removeShopAddress(
                                    controller.listShopAddress[index]['id'],
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
                                    ShopEditAddressScreen(addressIndex: index));
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
                            optional: controller.listShopAddress[index]
                                ['optional'],
                            id: controller.listShopAddress[index]['id'],
                            isSelectedAddress: controller.listShopAddress[index]
                                ['isDefault'],
                            province: controller.listShopAddress[index]
                                ['province'],
                            district: controller.listShopAddress[index]
                                ['district'],
                            name: controller.listShopAddress[index]['name'],
                            phoneNumber: controller.listShopAddress[index]
                                ['phoneNumber'],
                            street: controller.listShopAddress[index]['street'],
                            ward: controller.listShopAddress[index]['ward']),
                      ),
                    ),
                separatorBuilder: (ctx, index) =>
                    const SizedBox(height: TSizes.spaceBtwItems),
                itemCount: controller.listShopAddress.length),
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
