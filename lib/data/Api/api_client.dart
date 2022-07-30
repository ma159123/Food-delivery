import 'package:food_delivery/utils/constants/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


//GetxService used when you need to load some data from the internet instead of http client
//and int return response instead of http

class ApiClient extends GetConnect implements GetxService{
  late String token;
  final String appBaseUrl;
  late SharedPreferences sharedPreferences;
 late Map<String,String>_mainHeaders;
  ApiClient({required this.appBaseUrl,required this.sharedPreferences}){
    baseUrl=appBaseUrl;
    timeout=const Duration(seconds: 30); //هنا الوقت اللي هيحاول فيه يتصل بالسيرفر
    token=sharedPreferences.getString(AppConstants.IOKEN)??'';
   _mainHeaders={
     'content_type':'application/json; charset=UTF-8',
     'Authorization':'Bearer  $token'
   };
  }

  void updateHeaders(String token){
    _mainHeaders={
      'content_type':'application/json; charset=UTF-8',
      'Authorization':'Bearer  $token'
    };
  }
  Future<Response> getData(String url,{Map<String,String>?headers})async{
    try{
      Response response=await get(url,headers: headers??_mainHeaders);
      return response;
  }catch(e){
      return Response(statusCode: 1,bodyString: e.toString());
    }
}

Future<Response> postData(String uri,dynamic body)async{
    print(body.toString());
    try{
      Response response =await post(uri, body,headers: _mainHeaders);
      return response;
    }catch(e){
      print(e.toString());
      return Response(statusCode: 1,statusText: e.toString());
  }
}
}