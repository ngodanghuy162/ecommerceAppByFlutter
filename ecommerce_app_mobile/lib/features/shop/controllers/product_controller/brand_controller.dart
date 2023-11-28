
import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/brand_repository.dart';
import 'package:get/get.dart';

class BrandController extends GetxController {
  static BrandController get instance => Get.find();
  final _brandRepo = Get.put(BrandRepository());

  Future<String> createBrand(BrandModel brandModel) async{
    return await _brandRepo.createBrand(brandModel);
  }
}