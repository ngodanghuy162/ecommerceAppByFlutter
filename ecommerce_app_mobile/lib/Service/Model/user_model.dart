// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<Map<String, dynamic>> address;
  List<DocumentReference> wishlist;
  Map<String, List<String>> voucher;
  List<Map<String, dynamic>> cart;
  double totalIncome;
  String bankAccount;
  double totalConsumption;
  final String avatar_imgURL;

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
    this.avatar_imgURL =
        "https://i.pinimg.com/564x/d7/fe/2f/d7fe2f9979320bb57a1e4676eeb3e91a.jpg",
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
        isSell = isSell ?? false,
        cart = cart ?? [],
        totalIncome = totalIncome ?? 0.0,
        bankAccount = bankAccount ?? '',
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
        isSell: data?[isSellFieldName] ?? false,
        address: List<Map<String, dynamic>>.from(data?['address'] ?? []),
        wishlist: List<DocumentReference>.from(data?['wishlist'] ?? []),
        voucher: Map<String, List<String>>.from(data?['voucher'] ?? {}),
        cart: List<Map<String, dynamic>>.from(data?['cart'] ?? []),
        totalIncome: data?['totalIncome'] * 1.0 ?? 0.0,
        bankAccount: data?['bankAccount'] ?? '',
        totalConsumption: data?['totalConsumption'] * 1.0 ?? 0.0,
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
      'wishlist': wishlist.map((ref) => ref).toList(),
      'voucher': voucher,
      'cart': cart,
      'totalIncome': totalIncome,
      'bankAccount': bankAccount,
      'totalConsumption': totalConsumption,
      'avatar_imgURL': avatar_imgURL,
    };
  }
}
