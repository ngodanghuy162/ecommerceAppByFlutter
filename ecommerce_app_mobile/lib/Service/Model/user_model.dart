// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/common/constant/cloudFieldName/shop_field.dart';
import 'package:ecommerce_app_mobile/common/constant/cloudFieldName/user_model_field.dart';

class UserModel {
  String? id;
  String firstName;
  String lastName;
  String? userName;
  String email;
  String? password;
  String phoneNumber;
  bool isSell;
  List<Map<String, dynamic>>? address;
  List<String>? wishlist;
  List<String>? voucher;
  List<dynamic>? cart;
  // double totalIncome;
  String? bankAccount;
  double? totalConsumption;
  String? avatar_imgURL;

  // Hàm khởi tạo
  UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    this.userName,
    bool? isSell,
    required this.email,
    this.password,
    required this.phoneNumber,
    String? avatar_imgURL,
    this.address,
    List<String>? wishlist,
    List<String>? voucher,
    List<dynamic>? cart,
    String? bankAccount,
    double? totalConsumption,
  })  : wishlist = wishlist ?? [],
        voucher = voucher ?? [],
        isSell = isSell ?? false,
        cart = cart ?? [],
        bankAccount = bankAccount ?? '',
        avatar_imgURL = avatar_imgURL ??
            "https://i.pinimg.com/564x/d7/fe/2f/d7fe2f9979320bb57a1e4676eeb3e91a.jpg",
        totalConsumption = totalConsumption ?? 0.0;

  // ham khoi tao cho qua trinh dang ky
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? data = snapshot.data();

    return UserModel(
        id: snapshot.id,
        email: data?['email'] ?? '',
        password: data?['password'] ?? '',
        phoneNumber: data?['phone_number'] ?? '',
        firstName: data?['first_name'] ?? '',
        lastName: data?['last_name'] ?? '',

        // address: List<Map<String, dynamic>>.from(data?['address']),
        // wishlist: List<String>.from(data?['wishlist']),
        // voucher: Map<String, List<String>>.from(data?['voucher']),
        // cart: List<Map<String, dynamic>>.from(data?['cart']),
        //address: data?[addressFieldName],
        address: (data?[addressFieldName] as List)
            .map((item) => item as Map<String, dynamic>)
            .toList(),
        cart: (data?[cartFieldName] as List),
        // .map((item) => item as Map<String, dynamic>)
        // .toList(),
        // wishlist: data?[wishlistFieldName],
        wishlist: (data?[wishlistFieldName] as List)
            .map((item) => item as String)
            .toList(),
        voucher: (data?[voucherField] as List)
            .map((item) => item as String)
            .toList(),
        //   cart: data?[cartFieldName],
        isSell: data?[isSellFieldName] ?? false,
//        totalIncome: data?['totalIncome'] * 1.0 ?? 0.0,
        bankAccount: data?[bankAccountFieldName],
        // totalConsumption: data?[totalConsumptionFieldName],
        totalConsumption: data?[totalConsumptionFieldName]?.toDouble() ?? 0.0,
        avatar_imgURL: data?['avatar_imgURL']);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'phone_number': phoneNumber,
      'user_name': userName,
      'address': address,
      // 'wishlist': wishlist.map((ref) => ref).toList(),
      'wishlist': wishlist,
      'voucher': voucher,
      'cart': cart,
      //     'totalIncome': totalIncome,
      'bankAccount': bankAccount,
      'totalConsumption': totalConsumption,
      'avatar_imgURL': avatar_imgURL,
    };
  }
}
