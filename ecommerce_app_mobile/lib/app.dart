import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:ecommerce_app_mobile/utils/constants/text_strings.dart';
import 'package:ecommerce_app_mobile/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: TTexts.appName,
      navigatorObservers: [FlutterSmartDialog.observer],
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      builder: FlutterSmartDialog.init(),
      debugShowCheckedModeBanner: false,
      // initialBinding: GeneralBindings(),
      home: const Center(child: CircularProgressIndicator()),
      // home: const SellProductScreen(),
    );
  }
}
