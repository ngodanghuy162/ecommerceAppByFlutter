
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<String> getUserDocumentId(String id) async {
    final snapshot = await _db.collection('Users').doc(id).get();

    return 'ProductCategory/${snapshot.id}';
  }
}