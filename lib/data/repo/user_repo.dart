import 'package:food_delivery/data/Api/api_client.dart';
import 'package:food_delivery/utils/constants/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class UserRepo{
  ApiClient apiClient;
  UserRepo({required this.apiClient});
  
  Future<Response> getUserData()async{
    return await apiClient.getData(AppConstants.USER_DATA_URI );
  }
}