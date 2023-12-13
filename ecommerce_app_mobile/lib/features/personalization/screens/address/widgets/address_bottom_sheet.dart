import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:ecommerce_app_mobile/features/personalization/controllers/address_controller.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressBottomSheet extends StatefulWidget {
  const AddressBottomSheet({super.key});

  @override
  State<AddressBottomSheet> createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends State<AddressBottomSheet> {
  String? currentProvinceId;

  String? currentDistrictId;

  String? currentWardCode;
  final controller = Get.put(AddressController());
  final GlobalKey<ContainedTabBarViewState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return ContainedTabBarView(
      key: _key,
      tabBarProperties: const TabBarProperties(
        indicatorColor: Colors.black,
        labelStyle: TextStyle(
          color: Colors.black,
        ),
      ),
      tabs: const [
        Text('Province'),
        Text('District'),
        Text('Ward'),
      ],
      views: [
        Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: FutureBuilder(
            future: controller.getAllProvinceVN(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView(
                    children: [
                      ...snapshot.data!
                          .map(
                            (e) => ListTile(
                              onTap: () {
                                setState(() {
                                  currentProvinceId =
                                      e['ProvinceID'].toString();
                                  currentDistrictId = null;
                                  currentWardCode = null;
                                  controller.province.text = e['ProvinceName'];
                                  controller.address.text =
                                      controller.province.text;
                                  controller.provinceId = currentProvinceId;
                                  _key.currentState?.next();
                                });
                              },
                              title: Text(
                                e['ProvinceName'],
                              ),
                            ),
                          )
                          .toList()
                    ],
                  );
                }
              }
              return const SizedBox(
                height: 65,
              );
            },
          ),
        ),
        currentProvinceId == null
            ? Container()
            : Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: FutureBuilder(
                  future:
                      controller.getDistrictOfProvinceVN(currentProvinceId!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return ListView(
                          children: [
                            ...snapshot.data!
                                .map(
                                  (e) => ListTile(
                                    onTap: () {
                                      setState(() {
                                        currentDistrictId =
                                            e['DistrictID'].toString();
                                        currentWardCode = null;
                                        controller.district.text =
                                            e['DistrictName'];
                                        controller.address.text =
                                            '${controller.province.text}/${controller.district.text}';
                                        controller.districtid =
                                            currentDistrictId;
                                        _key.currentState?.next();
                                      });
                                    },
                                    title: Text(
                                      e['DistrictName'],
                                    ),
                                  ),
                                )
                                .toList()
                          ],
                        );
                      }
                    }
                    return const SizedBox(
                      height: 65,
                    );
                  },
                ),
              ),
        currentDistrictId == null
            ? Container()
            : Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: FutureBuilder(
                  future: controller.getWardOfDistrictOfVN(currentDistrictId!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return ListView(
                          children: [
                            ...snapshot.data!
                                .map(
                                  (e) => ListTile(
                                    onTap: () {
                                      currentWardCode =
                                          e['WardCode'].toString();
                                      controller.ward.text = e['WardName'];
                                      controller.address.text =
                                          '${controller.province.text}/${controller.district.text}/${controller.ward.text}';
                                      controller.wardCode = currentWardCode;
                                      Get.back();
                                    },
                                    title: Text(
                                      e['WardName'],
                                    ),
                                  ),
                                )
                                .toList()
                          ],
                        );
                      }
                    }
                    return const SizedBox(
                      height: 65,
                    );
                  },
                ),
              ),
      ],
      onChange: (index) {
        // switch (index) {
        //   case 0:
        //     currentWardId = null;
        //     currentDistrictId = null;
        //     break;
        //   case 1:
        //     currentWardId = null;
        //     break;
        //   case 2:
        //     break;
        // }
      },
    );
  }
}
