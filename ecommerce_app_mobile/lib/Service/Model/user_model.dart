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
  })  : address = address ?? [],
        wishlist = wishlist ?? [],
        voucher = voucher ?? {},
        cart = cart ?? [],
        totalIncome = totalIncome ?? 0.0,
        bankAccount = bankAccount ?? '',
        totalConsumption = totalConsumption ?? 0.0;

  // dki tk voi google
  CloudUserModel.registerByGg({
    required this.userId,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    List<Map<String, dynamic>>? address,
    List<DocumentReference>? wishlist,
    Map<String, List<String>>? voucher,
    List<Map<String, dynamic>>? cart,
    double? totalIncome,
    String? bankAccount,
    double? totalConsumption,
  })  : password = "",
        firstName = "",
        lastName = "",
        address = address ?? [],
        wishlist = wishlist ?? [],
        voucher = voucher ?? {},
        cart = cart ?? [],
        totalIncome = totalIncome ?? 0.0,
        bankAccount = bankAccount ?? '',
        totalConsumption = totalConsumption ?? 0.0;

  // ham khoi tao cho qua trinh dang ky
  factory CloudUserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return CloudUserModel(
      userId: snapshot.id,
      email: snapshot.data()?['email'],
      password: snapshot.data()?['password'],
      phoneNumber: snapshot.data()?['phone_number'],
      firstName: snapshot.data()?['first_name'],
      lastName: snapshot.data()?['first_name'],
      userName: snapshot.data()?['first_name'],
      address: List<Map<String, dynamic>>.from(snapshot.data()?['address']),
      wishlist: List<DocumentReference>.from(snapshot.data()?['wishlist']),
      voucher: Map<String, List<String>>.from(snapshot.data()?['voucher']),
      cart: List<Map<String, dynamic>>.from(snapshot.data()?['cart']),
      totalIncome: snapshot.data()?['totalIncome'],
      bankAccount: snapshot.data()?['bankAccount'],
      totalConsumption: snapshot.data()?['totalConsumption'],
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
