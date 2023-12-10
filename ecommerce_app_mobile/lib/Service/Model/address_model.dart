// ignore: depend_on_referenced_packages

class AddressModel {
  String id;
  String province;
  String district;
  String ward;
  String name;
  String street;
  String phoneNumber;
  bool isDefault;

  AddressModel(
      {required this.id,
      required this.phoneNumber,
      required this.name,
      required this.province,
      required this.district,
      required this.street,
      required this.ward,
      required this.isDefault});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'province': province,
      'district': district,
      'ward': ward,
      'street': street,
      'phoneNumber': phoneNumber,
      'name': name,
      'isDefault': isDefault,
    };
  }
}
