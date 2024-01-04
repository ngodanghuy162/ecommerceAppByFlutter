import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/order_model/order_model.dart';
import 'package:ecommerce_app_mobile/Service/Model/order_model/payment_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/address_repository.dart';
import 'package:ecommerce_app_mobile/Service/repository/order_respository/order_respository.dart';
import 'package:ecommerce_app_mobile/Service/repository/order_respository/payment_repository.dart';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/products/cart/coupon_widget.dart';
import 'package:ecommerce_app_mobile/common/widgets/success_screen/success_screen.dart';
import 'package:ecommerce_app_mobile/features/personalization/controllers/address_controller.dart';
import 'package:ecommerce_app_mobile/features/personalization/screens/address/address.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/cart/cart_items_widget/cart_items.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/statistics/controllers/statistics_controller.dart';
import 'package:ecommerce_app_mobile/navigation_menu.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/api_constants.dart'
    as api_constant;
import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';

class CheckoutScreen extends StatefulWidget {
  CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final addressController = Get.put(AddressController());
  late Map<String, dynamic>? defaultAdress;
  var isSuccess = false;
  final controller = Get.put(PaymentRepository());
  final userController = Get.put(UserRepository());
  final orderController = Get.put(OrderRepository());
  final addressRepository = Get.put(AddressRepository());

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    final currentUserModel = userController.currentUserModel;
    Map<String, dynamic> currentUserAddress = currentUserModel.address!
        .singleWhere((element) => element['isDefault']);
    return Scaffold(
      appBar: TAppBar(
          showBackArrow: true,
          title: Text("Order Review",
              style: Theme.of(context).textTheme.headlineSmall)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              //  const TCartItems(showAddRemoveButton: false),
              const SizedBox(height: TSizes.spaceBtwSections),
              const TCouponCode(),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              TRoundedContainer(
                showBorder: true,
                backgroundColor: dark ? TColors.black : TColors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: TSizes.sm,
                    bottom: TSizes.sm,
                    right: TSizes.sm,
                    left: TSizes.md,
                  ),
                  child: Column(
                    children: [
                      const TBillingPaymentSection(),
                      const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                      const Divider(),
                      TBillingAddressSection(
                        name: currentUserModel.firstName +
                            currentUserModel.lastName,
                        phoneNumber: currentUserModel.phoneNumber,
                        fullAddress: currentUserAddress != null
                            ? '${currentUserAddress['province']}, ${currentUserAddress['district']}, ${currentUserAddress['ward']}, ${currentUserAddress['street']}'
                            : '',
                      ),
                      const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () async {
            // final String id = await controller.addPaymentSuccess(
            //   PaymentModel(
            //     paymentDate: Timestamp.now(),
            //     userId: 'abc',
            //     paymentMethod: 'paypal',
            //     total: 10,
            //   ),
            // );

            // print(userController.currentUserModel.id);

            // print((await controller.getPaymentDetails(id)).toMap());

            // print(await addressRepository.shippingCostEstimate());
            print(await addressRepository.getShippingServiceAvailable());

            // defaultAdress = await addressController.getDefaultAddress();
            // print(defaultAdress);
            // orderController.addOrderSuccess(OrderModel(
            //     shopId: '1',
            //     package: [
            //       {
            //         'variant_id1': 'quantity1',
            //         'arraytest': [
            //           {'map1': 1, 'map2': 2}
            //         ]
            //       },
            //       {
            //         'variant_id2': 'quantity2',
            //       }
            //     ],
            //     paymentId: '1',
            //     status: 'pending',
            //     userId: '1',
            //     shopAddress: defaultAdress!,
            //     userAddress: defaultAdress!));
            /*

          
            Get.to(
              () => UsePaypal(
                sandboxMode: true,
                clientId: api_constant.clientId,
                secretKey: api_constant.secretKey,
                returnURL: api_constant.returnURL,
                cancelURL: api_constant.cancelURL,
                transactions: [
                  {
                    "amount": const {
                      "total": '10.12',
                      "currency": "USD",
                      "details": {
                        "subtotal": '10.12',
                        "shipping": '0',
                        "shipping_discount": 0
                      }
                    },
                    "description": "The payment transaction description.",
                    // "payment_options": {
                    //   "allowed_payment_method":
                    //       "INSTANT_FUNDING_SOURCE"
                    // },
                    "item_list": {
                      "items": const [
                        {
                          "name": "A demo product",
                          "quantity": 1,
                          "price": '10.12',
                          "currency": "USD"
                        }
                      ],

                      // shipping address is not required though
                      "shipping_address": {
                        "recipient_name": defaultAdress!['name'],
                        "line1": defaultAdress!['province'],
                        "line2": "",
                        "city": defaultAdress!['province'],
                        "country_code": "VN",
                        "postal_code": "73301",
                        "phone": defaultAdress!['phoneNumber'],
                        "state": defaultAdress!['district']
                      },
                    }
                  }
                ],
                note: "Contact us for any questions on your order.",
                onSuccess: (Map params) async {
                  print("onSuccess: $params");

                  if (!isSuccess) {
                    isSuccess = true;
                    await SmartDialog.show(
                      animationType: SmartAnimationType.fade,
                      builder: (context) => SuccessScreen(
                          title: "Payment success",
                          subtitle: "Your items will be shipped soon",
                          callback: () async {
                            SmartDialog.dismiss();
                            isSuccess = false;
                            Get.offAll(const NavigationMenu());
                          },
                          image: TImages.successfulPaymentIcon),
                    );
                  }
                },
                onError: (error) {
                  print("onError: $error");
                },
                onCancel: (params) {
                  print('cancelled: $params');
                },
              ),
            ); */
          },
          child: const Text("Checkout \$256"),
        ),
      ),
    );
  }
}
