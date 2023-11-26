import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:ecommerce_app_mobile/Service/Repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' show log;

class GgAuthProvider {
  static final GgAuthProvider ggProvider = GgAuthProvider._internal();

  // Phương thức factory để trả về thể hiện duy nhất của FirebaseAuthProvider
  factory GgAuthProvider() {
    return ggProvider;
  }

  // Hàm khởi tạo internal (chỉ được gọi bởi factory constructor)
  GgAuthProvider._internal();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      /*   if (kIsWeb) {
        log("not android");
        _googleSignIn = GoogleSignIn(
            clientId:
                '1002703289584-sufgt9jpo1geh923j0svgrnctrk2ud6d.apps.googleusercontent.com');
      }*/

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      // Trigger the authentication flow
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );
      // Thử đăng nhập

      // Once signed in, return the UserCredential
      UserCredential? userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? authUser = userCredential.user;
      String emailUser = authUser!.email.toString();
      log(emailUser);
      CloudUserModel? currentCloudUser =
          await UserRepository.userRepository.getCloudUserByEmail(emailUser);
      log(currentCloudUser.toString());
      if (currentCloudUser == null) {
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
      log("6666666");
      return userCredential;
    } on FirebaseAuthException catch (e) {
      log(e.code.toString());
      throw Exception("Loi FirebaseAuthException");
    }
  }

  Future<void> logOutGoogle() async {
    late final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }
}
