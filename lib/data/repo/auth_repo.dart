import 'package:food_delivery/data/Api/api_client.dart';
import 'package:food_delivery/models/sign_up_model.dart';
import 'package:food_delivery/utils/constants/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo extends GetxService{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.sharedPreferences,required this.apiClient});


 Future<Response> registration(SignUpModel signUpModel)async{
   return await apiClient.postData(AppConstants.Register_URI, signUpModel.toJson());
  }


  Future<Response> login(String phone,String password)async{
    return await apiClient.postData(AppConstants.LOGIN_URI, {'phone':phone,'password':password});
  }


 Future<bool> saveToken(String token){
   apiClient.token=token;
   apiClient.updateHeaders(token);
   return sharedPreferences.setString(AppConstants.IOKEN, token);
  }

 bool isUserLogin(){
   return  sharedPreferences.containsKey(AppConstants.IOKEN);
  }

Future<void> savePhoneAndPassword(String number,String password) async{
  try{
   await sharedPreferences.setString(AppConstants.PHONE, number);
  await  sharedPreferences.setString(AppConstants.PASSWORD, password);
  }catch(e){
    throw(e);
  }
}


  String getUserToken(){
    return sharedPreferences.getString(AppConstants.IOKEN)??'none';
  }

  bool clearSharedData(){
   sharedPreferences.remove(AppConstants.IOKEN);
   sharedPreferences.remove(AppConstants.PHONE);
   sharedPreferences.remove(AppConstants.PASSWORD);
   apiClient.token='';
   apiClient.updateHeaders('');
   return true;
  }

}