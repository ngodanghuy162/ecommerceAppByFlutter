import 'package:ecommerce_app_mobile/Service/Auth/firebaseauth_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app_mobile/app.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();

  await FirebaseAuthProvider.firebaseAuthProvider.initalize();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const App());
}
