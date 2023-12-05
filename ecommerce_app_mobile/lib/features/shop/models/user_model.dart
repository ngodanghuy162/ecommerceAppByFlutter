import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final List<String>? address;
  final String? bankAccount;
  final List<String>? cart;
  final String email;
  final String password;
  final String phone_number;
  final double? totalConsumption;
  final double? totalIncome;
  final String? voucher;
  final List<String>? wishlist;

  UserModel({
    this.address,
    this.bankAccount, 
    this.cart,
    required this.email,
    required this.password,
    required this.phone_number,
    this.totalConsumption,
    this.totalIncome,
    this.voucher,
    this.wishlist,
  });

  toJson() {
    return {
      'address': address,
      'bankAccount': bankAccount,
      'cart': cart,
      'email': email,
      'password': password,
      'phone_number': phone_number,
      'totalConsumption': totalConsumption,
      'totalIncome': totalIncome,
      'voucher': voucher,
      'wishlist': wishlist,
    };
  }

  factory UserModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      address: data['address'],
      bankAccount: data['bankAccount'],
      cart: data['cart'],
      email: data['email'],
      password: data['password'],
      phone_number: data['phone_number'],
      totalConsumption: data['totalConsumption'],
      totalIncome: data['totalIncome'],
      voucher: data['voucher'],
      wishlist: data['wishlist'],
    );
  }

}