import '../Model/user_model.dart';

abstract class AuthProvider {
  Future<void> initalize();
  
  
  CloudUserModel? get currentUser;

  Future<CloudUserModel> logIn({
    required String email,
    required String password,
  });

  Future<CloudUserModel> createUser({
    required String email,
    required String password,
  });

  Future<void> logOut();

  Future<void> sendEmailVerify();
}
