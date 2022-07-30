import 'package:food_delivery/models/products_model.dart';
import 'package:get/get.dart';

import '../repo/recommended_products_repo.dart';

class RecommendedProductController extends GetxController {
  RecommendedProductRepo recommendedDataRepo;

  RecommendedProductController({required this.recommendedDataRepo});

  List<dynamic> _recommendedProductList = [];

  List<dynamic> get recommendedProductList => _recommendedProductList;

  bool _isLoaded=false;
  bool get isLoaded=>_isLoaded;
  Future<void> getRecommendedProductList() async {
    Response response = await recommendedDataRepo.getRecommendedProductRepo();
    if (response.statusCode == 200) {
      print("got data");
      _recommendedProductList = [];
      _recommendedProductList.addAll(ProductsModel.fromJson(response.body).products);
      _isLoaded=true;
      update();
    } else {
      // print("got data");
    }
  }
}
