import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: TAppBar(showBackArrow: true),
    );
  }
}
