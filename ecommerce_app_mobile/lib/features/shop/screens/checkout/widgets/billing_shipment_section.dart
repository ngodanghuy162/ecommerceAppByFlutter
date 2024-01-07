import 'package:ecommerce_app_mobile/Service/repository/address_repository.dart';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/texts/section_heading.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/checkout/checkout_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/checkout/widgets/billing_amout_section.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TBillingShipmentSection extends StatefulWidget {
  const TBillingShipmentSection({
    super.key,
    required this.shipmentServiceAvailable,
    this.subTotal,
    required this.defaultShopAddress,
    this.items,
    required this.shopEmail,
  });

  final List shipmentServiceAvailable;
  final double? subTotal;
  final Map<String, dynamic> defaultShopAddress;
  final List<Map<String, dynamic>>? items;
  final String shopEmail;

  @override
  State<TBillingShipmentSection> createState() =>
      _TBillingShipmentSectionState();
}

class _TBillingShipmentSectionState extends State<TBillingShipmentSection> {
  late Map currentService;
  final addressRepository = Get.put(AddressRepository());
  final userRepository = Get.put(UserRepository());
  final controller = Get.put(CheckoutController());
  void showBottomModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ...widget.shipmentServiceAvailable.map((e) => Card(
                      elevation: 5,
                      color: TColors.primary,
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            currentService = e;
                            Get.back();
                          });
                        },
                        leading: const Icon(
                          Iconsax.truck_fast,
                          color: TColors.light,
                        ),
                        title: Text(
                          e['short_name'],
                          style: const TextStyle(
                            color: TColors.light,
                          ),
                        ),
                        subtitle: const Text(
                          'Shipment method',
                          style: TextStyle(
                            color: TColors.light,
                          ),
                        ),
                        trailing: const Icon(
                          Iconsax.arrow_right_34,
                          color: TColors.light,
                        ),
                      ),
                    ))
              ],
            ));
      },
    );
  }

  @override
  void initState() {
    super.initState();
    currentService = widget.shipmentServiceAvailable.first;
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      children: [
        TSectionHeading(
          title: "Shipment Method",
          buttonTitle: "Change",
          onPressed: () {
            showBottomModal(context);
          },
        ),
        const SizedBox(
          height: TSizes.spaceBtwItems / 2,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TRoundedContainer(
              width: 60,
              height: 35,
              backgroundColor: dark ? TColors.dark : TColors.white,
              padding: const EdgeInsets.all(TSizes.sm),
              child: const Icon(Iconsax.truck_fast),
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems / 2,
            ),
            Text(
              currentService['short_name'],
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],
        ),
        const SizedBox(height: TSizes.sm),
        const Divider(
          height: 10,
          thickness: 1,
          indent: 0,
          endIndent: 0,
          color: TColors.divider,
        ),
        FutureBuilder(
          future: addressRepository.shippingCostEstimate(
              currentService['service_id'].toString(),
              widget.defaultShopAddress['districtId'],
              userRepository.getDefaultAddress()['districtId'],
              userRepository.getDefaultAddress()['wardCode'],
              widget.items!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  final prev = controller.costList
                      .where((p0) => ((p0 as Map).keys.contains('shopEmail') &&
                          p0['shopEmail'] == widget.shopEmail))
                      .toList();

                  if (prev.isNotEmpty) {
                    for (var element in prev) {
                      controller.costList.remove(element);
                    }
                  }

                  controller.costList.add({
                    'shopEmail': widget.shopEmail,
                    'cost': {
                      'subTotal': widget.subTotal!.toStringAsFixed(2),
                      'shippingFee':
                          ((snapshot.data!['total'] / 24375) as double)
                              .toStringAsFixed(2),
                      'total':
                          (widget.subTotal! + snapshot.data!['total'] / 24375)
                              .toStringAsFixed(2),
                    }
                  });
                });

                // print(controller.listCost);
                return TBillingAmountSection(
                  subTotal: widget.subTotal!.toStringAsFixed(2),
                  shippingFee: ((snapshot.data!['total'] / 24375) as double)
                      .toStringAsFixed(2),
                  total: (widget.subTotal! + snapshot.data!['total'] / 24375)
                      .toStringAsFixed(2),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                return const Center(child: Text("smt went wrong"));
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}
