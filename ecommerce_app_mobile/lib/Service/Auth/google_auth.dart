import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:ecommerce_app_mobile/Service/Repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      //  if (Platform.isIOS || Platform.isAndroid) {
      log("00000");
      GoogleSignIn _googleSignIn;
      log("0.555555");
      // = GoogleSignIn(
      //     clientId:
      //         '1002703289584-sufgt9jpo1geh923j0svgrnctrk2ud6d.apps.googleusercontent.com');
      if (kIsWeb) {
        log("not android");
        _googleSignIn = GoogleSignIn(
            clientId:
                '1002703289584-sufgt9jpo1geh923j0svgrnctrk2ud6d.apps.googleusercontent.com');
        log("android");
      } else {
        log("android");
        _googleSignIn = GoogleSignIn(
            clientId:
                '1002703289584-4ln574a6qi4mfb7fv95cmg0n1439e774.apps.googleusercontent.com');
      }
      // } else if (Platform.isIOS) {
      //   _googleSignIn = GoogleSignIn(
      //       clientId:
      //           '1002703289584-or9ncnt9appnbdnbln95grg8ar5h0a2c.apps.googleusercontent.com');
      // } else {
      //   _googleSignIn = GoogleSignIn(
      //       clientId:
      //           '1002703289584-sufgt9jpo1geh923j0svgrnctrk2ud6d.apps.googleusercontent.com');
      // }

// ...

      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      // Trigger the authentication flow
      // final GoogleSignInAccount? googleSignInAccount =
      //     await GoogleSignIn().signIn();
      log("11111");
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;

      log("2222222");
      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );
      log("3333333");
      // Thử đăng nhập

      // Once signed in, return the UserCredential
      UserCredential? userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      log("444444");
      User? authUser = userCredential.user;
      String emailUser = authUser!.email.toString();
      log(emailUser);
      CloudUserModel? currentCloudUser =
          await UserRepository.userRepository.getCloudUserByEmail(emailUser);
      log("ko 111111");
      log(currentCloudUser.toString());
      if (currentCloudUser == null) {
        log("ko co user cloud o trong google_auth.dart");

        // Kiểm tra và gán giá trị mặc định nếu là null
        String userName = authUser?.displayName ?? 'Unknown';
        String userEmail = authUser?.email ?? 'Unknown';

        await UserRepository.userRepository.createUser(
          CloudUserModel.registerByGg(
            userId: authUser!.uid,
            userName: userName,
            email: userEmail,
          ),
        );
      }
      log("6666666");
      return userCredential;
      // GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // // Once signed in, return the UserCredential
      // return await FirebaseAuth.instance.signInWithPopup(googleProvider);
      // } else {
      //   log("Da goi ham sign in o phan else if ");
      //   // Create a new provider
      //   GoogleAuthProvider googleProvider = GoogleAuthProvider();
      //   log("Da goi ham sign in o phan else if 2 ");
      //   // Once signed in, return the UserCredential
      //   return await FirebaseAuth.instance.signInWithProvider(googleProvider);

      //   // Or use signInWithRedirect
      //   // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
      // }
    } on FirebaseAuthException catch (e) {
      log("-----e.code here");
      log(e.code.toString());
      log("-----");
      throw Exception("Loi FirebaseAuthException");
    }
  }

  Future<void> logOutGoogle() async {
    late final GoogleSignIn _googleSignIn;
    // = GoogleSignIn(
    //     clientId:
    //         '1002703289584-sufgt9jpo1geh923j0svgrnctrk2ud6d.apps.googleusercontent.com');
    if (kIsWeb) {
      log("not android");
      _googleSignIn = GoogleSignIn(
          clientId:
              '1002703289584-sufgt9jpo1geh923j0svgrnctrk2ud6d.apps.googleusercontent.com');
      log("android");
    } else {
      log("android");
      _googleSignIn = GoogleSignIn(
          clientId:
              '1002703289584-sufgt9jpo1geh923j0svgrnctrk2ud6d.apps.googleusercontent.com');
    }
    await _googleSignIn.signOut();
  }
}
