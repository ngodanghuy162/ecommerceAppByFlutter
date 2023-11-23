import 'dart:io';

import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:ecommerce_app_mobile/Service/Repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' show log;

class GoogleProvider {
  static final GoogleProvider ggProvider = GoogleProvider._internal();

  // Phương thức factory để trả về thể hiện duy nhất của FirebaseAuthProvider
  factory GoogleProvider() {
    return ggProvider;
  }

  // Hàm khởi tạo internal (chỉ được gọi bởi factory constructor)
  GoogleProvider._internal();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (Platform.isIOS || Platform.isAndroid) {
        log("Da goi ham sign in");
        // Trigger the authentication flow
        final GoogleSignInAccount? googleSignInAccount =
            await GoogleSignIn().signIn();
        log("Da goi ham sign in 1");
        // Obtain the auth details from the request
        final GoogleSignInAuthentication? googleSignInAuthentication =
            await googleSignInAccount?.authentication;

        log("Da goi ham authenticantion ");
        // Create a new credential
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication?.accessToken,
          idToken: googleSignInAuthentication?.idToken,
        );
        log("Da goi ham credential ");
        // Thử đăng nhập

        // Once signed in, return the UserCredential
        UserCredential? userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        log("Da goi ham sign in creadeential ");
        User? authUser = userCredential.user;
        log("Da goi dong 39 gg auth - sau dong lay auth user");
        if (await UserRepository.userRepository
                .getCloudUserByEmail(userCredential.user!.email.toString()) ==
            null) {
          log("ko co user cloud o trong google_auth.dart");
          await UserRepository.userRepository.createUser(
              CloudUserModel.registerByGg(
                  userId: authUser!.uid,
                  userName: authUser.displayName.toString(),
                  email: authUser.email.toString(),
                  phoneNumber: authUser.phoneNumber.toString()));
        }

        return userCredential;
      } else if (kIsWeb) {
        log("Da goi ham sign in o phan else if ");
        // Create a new provider
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        await googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

        // Once signed in, return the UserCredential
        return await FirebaseAuth.instance.signInWithPopup(googleProvider);

        // Or use signInWithRedirect
        // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
      } else {
        log("Da goi ham sign in o phan else");
      }
    } on FirebaseAuthException catch (e) {
      log("-----e.code here");
      log(e.code);
      log("-----");
    } catch (_) {
      throw Exception();
    }
    return null;
  }
}
