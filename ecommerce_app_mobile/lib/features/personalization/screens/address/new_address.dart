import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/features/personalization/controllers/address_controller.dart';
import 'package:ecommerce_app_mobile/features/personalization/screens/address/widgets/address_bottom_sheet.dart';
import 'package:ecommerce_app_mobile/features/personalization/screens/address/widgets/custom.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:iconsax/iconsax.dart';

class NewAddressScreen extends StatefulWidget {
  const NewAddressScreen({Key? key}) : super(key: key);

  @override
  State<NewAddressScreen> createState() => _NewAddressScreenState();
}

class _NewAddressScreenState extends State<NewAddressScreen> {
  final controller = Get.put(AddressController());
  final userRepository = Get.put(UserRepository());

  @override
  void initState() {
    super.initState();
    // controller.address.text = 'Province/District/Ward';
  }

  @override
  Widget build(BuildContext context) {
    final popContext = context;
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: const Text('Add new address'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: controller.name,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.user),
                    labelText: 'Name',
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: controller.phoneNumber,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.mobile),
                    labelText: 'Phone number',
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: controller.address,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.building),
                    labelText: 'Province/District/Ward',
                  ),
                  readOnly: true,
                  onTap: () async {
                    await Get.bottomSheet(
                      const AddressBottomSheet(),
                      backgroundColor: Colors.white,
                    );
                  },
                  minLines: 1,
                  maxLines: 3,
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: controller.street,
                  readOnly: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.building_31),
                    labelText: 'Street',
                  ),
                  onTap: () async {
                    showModalBottomSheet(
                      useSafeArea: true,
                      context: context,
                      isScrollControlled: true,
                      isDismissible: true,
                      builder: (ctx) => CustomSearch(),
                    );
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: controller.optional,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.mobile),
                    labelText: 'Optional',
                  ),
                ),
                const SizedBox(height: TSizes.defaultSpace),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller.addUserAddress();
                      controller.clearTextField();
                      // ignore: use_build_context_synchronously
                      Navigator.of(popContext).pop();
                    },
                    child: const Text('Save'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
