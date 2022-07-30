
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

import '../../utils/constants/app_constants.dart';
import '../Api/api_client.dart';

class RecommendedProductRepo extends GetxService{
  ApiClient apiClient;
  RecommendedProductRepo({required this.apiClient});
  Future<Response>getRecommendedProductRepo()async{
    return await apiClient.getData(AppConstants.RECOMMENDED_PRODUCT_URI);
  }
}