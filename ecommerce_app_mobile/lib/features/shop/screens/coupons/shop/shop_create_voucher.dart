import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ShopCreateVoucher extends StatefulWidget {
  const ShopCreateVoucher({super.key});

  @override
  State<ShopCreateVoucher> createState() => _ShopCreateVoucherState();
}

class _ShopCreateVoucherState extends State<ShopCreateVoucher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text("Create Voucher"),
      ),
      body: Container(),
    );
  }
}
