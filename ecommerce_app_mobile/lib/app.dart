import 'package:ecommerce_app_mobile/features/shop/screens/sell_product/sell_product.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/store/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:ecommerce_app_mobile/utils/constants/text_strings.dart';
import 'package:ecommerce_app_mobile/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: TTexts.appName,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      // initialBinding: GeneralBindings(),
      // home: StoreScreen(),
      home: const SellProductScreen(),
    );
  }
}
