import 'package:food_delivery/data/Api/api_client.dart';
import 'package:food_delivery/utils/constants/app_constants.dart';
import 'package:get/get.dart';

class PopularProductRepo extends GetxService{
  ApiClient apiClient;
  PopularProductRepo({required this.apiClient});
  Future<Response>getPopularProductRepo()async{
    return await apiClient.getData(AppConstants.POPULAR_PRODUCT_URI);
  }
}