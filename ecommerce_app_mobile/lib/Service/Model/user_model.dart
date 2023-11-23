// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudUserModel {
  String userId;
  String firstName;
  String lastName;
  String userName;
  String email;
  String password;
  String phoneNumber;
  List<Map<String, dynamic>> address;
  List<DocumentReference> wishlist;
  Map<String, List<String>> voucher;
  List<Map<String, dynamic>> cart;
  double totalIncome;
  String bankAccount;
  double totalConsumption;

  // Hàm khởi tạo
  CloudUserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    List<Map<String, dynamic>>? address,
    List<DocumentReference>? wishlist,
    Map<String, List<String>>? voucher,
    List<Map<String, dynamic>>? cart,
    double? totalIncome,
    String? bankAccount,
    double? totalConsumption,
  })  : address = address ?? [],
        wishlist = wishlist ?? [],
        voucher = voucher ?? {},
        cart = cart ?? [],
        totalIncome = totalIncome ?? 0.0,
        bankAccount = bankAccount ?? '',
        totalConsumption = totalConsumption ?? 0.0;

  // ham khoi tao cho qua trinh dang ky bang gmail
  CloudUserModel.register({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    List<Map<String, dynamic>>? address,
    List<DocumentReference>? wishlist,
    Map<String, List<String>>? voucher,
    List<Map<String, dynamic>>? cart,
    double? totalIncome,
    String? bankAccount,
    double? totalConsumption,
  })  : address = [],
        wishlist = [],
        voucher = {},
        cart = [],
        totalIncome = 0.0,
        bankAccount = '',
        totalConsumption = 0.0;

  // dki tk voi google
  CloudUserModel.registerByGg({
    required this.userId,
    required this.userName,
    required this.email,
    List<Map<String, dynamic>>? address,
    List<DocumentReference>? wishlist,
    Map<String, List<String>>? voucher,
    List<Map<String, dynamic>>? cart,
    double? totalIncome,
    String? bankAccount,
    double? totalConsumption,
  })  : password = "",
        phoneNumber = "",
        firstName = "",
        lastName = "",
        address = [],
        wishlist = [],
        voucher = {},
        cart = [],
        totalIncome = 0.0,
        bankAccount = '',
        totalConsumption = 0.0;

  // ham khoi tao cho qua trinh dang ky
  factory CloudUserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();

    return CloudUserModel(
      userId: snapshot.id,
      email: data?['email'] ?? '',
      password: data?['password'] ?? '',
      phoneNumber: data?['phone_number'] ?? '',
      firstName: data?['first_name'] ?? '',
      lastName: data?['first_name'] ?? '',
      userName: data?['first_name'] ?? '',
      address: List<Map<String, dynamic>>.from(data?['address'] ?? []),
      wishlist: List<DocumentReference>.from(data?['wishlist'] ?? []),
      voucher: Map<String, List<String>>.from(data?['voucher'] ?? {}),
      cart: List<Map<String, dynamic>>.from(data?['cart'] ?? []),
      totalIncome: data?['totalIncome'] ?? 0,
      bankAccount: data?['bankAccount'] ?? '',
      totalConsumption: data?['totalConsumption'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'phone_number': phoneNumber,
      'address': address,
      'wishlist': wishlist.map((ref) => ref).toList(),
      'voucher': voucher,
      'cart': cart,
      'totalIncome': totalIncome,
      'bankAccount': bankAccount,
      'totalConsumption': totalConsumption,
    };
  }
}
