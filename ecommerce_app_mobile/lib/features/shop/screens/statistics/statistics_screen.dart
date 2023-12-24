import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/statistics/widgets/annotated_chart.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/statistics/widgets/dropdown.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/statistics/widgets/bar_graph.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/statistics/widgets/statistic_number.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final dark = THelperFunctions.isDarkMode(context);
    return const Scaffold(
      appBar: TAppBar(title: Text("Statistics"), showBackArrow: true),
      body: Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            TRoundedContainer(
                showBorder: true,
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropDownMenu(),
                    Divider(
                      height: 1,
                    ),
                    SizedBox(height: TSizes.spaceBtwSections),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatisticNumber(
                            text: "Total", color: Colors.red, number: 20),
                        StatisticNumber(
                            text: "Waiting", color: Colors.black, number: 10),
                        StatisticNumber(
                            text: "In Shipping", color: Colors.blue, number: 5),
                        StatisticNumber(
                            text: "Success", color: Colors.green, number: 5)
                      ],
                    ),
                  ],
                )),
            SizedBox(height: TSizes.spaceBtwSections),
            SizedBox(
              height: 350,
              child: BarChartGraph(),
            ),
            SizedBox(height: TSizes.spaceBtwSections),
            AnnotatedChart(),
            SizedBox(height: TSizes.spaceBtwSections),
            Divider(
              height: 0.7,
            ),
            SizedBox(height: TSizes.spaceBtwSections),
            Row(
              children: [
                Text(
                  "Received Money:",
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
                Text(" \$300")
              ],
            )
          ],
        ),
      ),
    );
  }
}
