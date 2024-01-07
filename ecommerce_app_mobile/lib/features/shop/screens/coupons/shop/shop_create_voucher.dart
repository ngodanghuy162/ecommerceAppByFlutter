import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ShopCreateVoucher extends StatefulWidget {
  const ShopCreateVoucher({super.key});

  @override
  State<ShopCreateVoucher> createState() => _ShopCreateVoucherState();
}

class _ShopCreateVoucherState extends State<ShopCreateVoucher> {
  double discount = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text("Create Voucher"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter your name voucher',
                border: OutlineInputBorder(), // Customize border
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Due date',
                border: OutlineInputBorder(), // Customize border
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(), // Customize border
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Slider(
              value: discount,
              onChanged: (newRating) {
                setState(() {
                  discount = newRating;
                });
              },
              min: 0,
              max: 100,
              divisions: 100,
              label: "${discount.toInt()}%",
            )
          ],
        ),
      ),
    );
  }
}
