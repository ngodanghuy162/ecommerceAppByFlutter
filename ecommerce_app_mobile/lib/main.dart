import 'package:ecommerce_app_mobile/Service/repository/authentication_repository.dart';
import 'package:ecommerce_app_mobile/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app_mobile/app.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  //saves app config
  await GetStorage.init('app-setting-configs');

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then(
    (value) => Get.put(
      AuthenticationRepository(),
    ),
  );
  runApp(const App());
}
