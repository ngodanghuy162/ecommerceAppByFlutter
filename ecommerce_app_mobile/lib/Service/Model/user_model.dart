// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudUserModel {
 final String userId;
 final  String email;
 final String password;
 final String phoneNumber;
 final List<Map<String, dynamic>> address;
  final List<DocumentReference> wishlist;
 final Map<String, List<String>> voucher;
 final List<Map<String, dynamic>> cart;
  final double totalIncome;
 final String bankAccount;
 final  double totalConsumption;

  CloudUserModel({required this.userId, required this.email, required this.password, required this.phoneNumber, required this.address, required this.wishlist, required this.voucher, required this.cart, required this.totalIncome, required this.bankAccount, required this.totalConsumption});

  factory CloudUserModel.fromSnapshot(DocumentSnapshot snapshot) {
    return CloudUserModel(
      userId: snapshot.id,
      email: snapshot['email'],
      password: snapshot['password'],
      phoneNumber: snapshot['phone_number'],
      address: List<Map<String, dynamic>>.from(snapshot['address']),
      wishlist: List<DocumentReference>.from(snapshot['wishlist']),
      voucher: Map<String, List<String>>.from(snapshot['voucher']),
      cart: List<Map<String, dynamic>>.from(snapshot['cart']),
      totalIncome: snapshot['totalIncome'],
      bankAccount: snapshot['bankAccount'],
      totalConsumption: snapshot['totalConsumption'],
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
