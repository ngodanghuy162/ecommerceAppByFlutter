import 'package:ecommerce_app_mobile/features/shop/models/product_model/brand_model.dart';
import 'package:ecommerce_app_mobile/repository/product_repository/brand_repository.dart';
import 'package:get/get.dart';

class BrandController extends GetxController {
  static BrandController get instance => Get.find();

  final _brandRepo = Get.put(BrandRepository());

  var choosedBrand = BrandModel(name: "name").obs;

  List<BrandModel> listBrand = [];

  Future<String> createBrand(BrandModel brandModel) async {
    return await _brandRepo.createBrand(brandModel);
  }

  Future<String> checkDuplicatedBrand(String name) async {
    return await _brandRepo.checkDuplicatedBrand(name);
  }

  Future<List<BrandModel>> getAllBrandsData() async {
    return await _brandRepo.queryAllBrands();
  }

  Future<BrandModel> getBrandById(String brandID) async {
    return await _brandRepo.queryBrandById(brandID);
  }
}
