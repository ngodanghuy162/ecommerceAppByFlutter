import 'dart:developer';

import 'package:ecommerce_app_mobile/Service/Repository/user_repository.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FbAuthProvider {
  static final FbAuthProvider fbProvider = FbAuthProvider._internal();

  // Phương thức factory để trả về thể hiện duy nhất của FirebaseAuthProvider
  factory FbAuthProvider() {
    return fbProvider;
  }

  // Hàm khởi tạo internal (chỉ được gọi bởi factory constructor)
  FbAuthProvider._internal();

  Future<UserCredential?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        // Create a credential from the access token (
        // dang dangloi dang loi o day bi null nhe);
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);

        // Once signed in, return the UserCredential
        UserCredential? userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        User? authUser = userCredential.user;
        String? emailUser = authUser!.email;
        String? phoneNumber = authUser.phoneNumber;
        CloudUserModel? currentCloudUser2;
        CloudUserModel? currentCloudUser = await UserRepository.userRepository
            .getCloudUserByEmail(emailUser.toString());
        log(currentCloudUser.toString());
        if (phoneNumber != null && emailUser == null) {
          currentCloudUser2 = await UserRepository.userRepository
              .getCloudUserByPhoneNumber(authUser.phoneNumber.toString());
        }
        if (currentCloudUser == null && currentCloudUser2 == null) {
          currentCloudUser = await UserRepository.userRepository
              .getCloudUserByPhoneNumber(authUser.phoneNumber.toString());
          // Kiểm tra và gán giá trị mặc định nếu là null
          String userName = authUser.displayName ?? 'Unknown';
          String userEmail = authUser.email ?? 'Unknown';

          await UserRepository.userRepository.createUser(
            CloudUserModel.registerByGg(
              userId: authUser.uid,
              userName: userName,
              email: userEmail,
            ),
          );
        }
        return userCredential;
      } else {
        throw FirebaseAuthException(
          code: 'Facebook Login Failed',
          message: 'The Facebook login was not successful.',
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication exceptions
      print('Firebase Auth Exception: ${e.message}');
      throw e; // rethrow the exception
    } catch (e) {
      // Handle other exceptions
      print('Other Exception: $e');
      throw e; // rethrow the exception
    }
  }

  Future<void> logOutFb() async {
    try {
      return await FacebookAuth.instance.logOut();
    } catch (e) {
      print("Error signing out from Facebook: $e");
    }
  }
}
