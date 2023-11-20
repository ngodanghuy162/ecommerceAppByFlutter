import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:ecommerce_app_mobile/Service/Repository/user_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ecommerce_app_mobile/firebase_options.dart';
import 'auth_exception.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, User;

class FirebaseAuthProvider {
// Khai báo thể hiện duy nhất của FirebaseAuthProvider
  static final FirebaseAuthProvider firebaseAuthProvider =
      FirebaseAuthProvider._internal();

  // Phương thức factory để trả về thể hiện duy nhất của FirebaseAuthProvider
  factory FirebaseAuthProvider() {
    return firebaseAuthProvider;
  }

  // Hàm khởi tạo internal (chỉ được gọi bởi factory constructor)
  FirebaseAuthProvider._internal();

  User? get currentFirebaseUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user;
    }
    return null;
  }

  Future<User> createUser(
      {required String firstName,
      required String lastName,
      required String userName,
      required String email,
      required String password,
      required String phoneNumber}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = currentFirebaseUser;
      UserRepository.userRepository.createUser(new CloudUserModel.register(
          userId: user!.uid,
          firstName: firstName,
          lastName: lastName,
          userName: userName,
          email: email,
          password: password,
          phoneNumber: phoneNumber));
      // ignore: unnecessary_null_comparison
      if (user != null) {
        return user;
      } else {
        throw Exception("User bang null");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  Future<User> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentFirebaseUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  Future<void> sendEmailVerify() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  initalize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
