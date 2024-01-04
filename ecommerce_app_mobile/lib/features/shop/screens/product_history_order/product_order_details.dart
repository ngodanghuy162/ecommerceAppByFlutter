import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProductOrderDetails extends StatefulWidget {
  const ProductOrderDetails({super.key});

  @override
  State<ProductOrderDetails> createState() => _ProductOrderDetailsState();
}

class _ProductOrderDetailsState extends State<ProductOrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text("Order details"),
      ),
      body: ListView(
        children: [
          Container(
            width: THelperFunctions.screenWidth(),
            height: 100,
            decoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 12,
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: const Icon(
                  Iconsax.location,
                  size: TSizes.md,
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'name',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: TSizes.sm / 2),
                      const Text(
                        'phoneNumber',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: TSizes.sm / 2),
                      const Text(
                        // optional == ''
                        //     ? '$street, $ward, $district, $province'
                        //     : '$optional, $street, $ward, $district, $province',
                        'Dia chi abc, Dia chi abc, Dia chi abc, Dia chi abc, Dia chi abc, Dia chi abc',
                        softWrap: true,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
