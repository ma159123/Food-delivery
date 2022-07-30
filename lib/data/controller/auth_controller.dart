import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:food_delivery/data/repo/auth_repo.dart';
import 'package:food_delivery/models/response_model.dart';
import 'package:food_delivery/models/sign_up_model.dart';
import 'package:get/get.dart';

import '../../models/user_model.dart';
class AuthController extends GetxController {
  late AuthRepo authRepo;

  AuthController({required this.authRepo});
   bool _isLoading=false;
  bool get isLoading {
    return _isLoading;
  }

  Map<String,dynamic>_userData={};          //late Map<String,dynamic>_userData;  i think may be useful
  Map<String,dynamic> get userData=>_userData;

  UserModel? _userModel;
  UserModel? get userModel=>_userModel;

  bool _checkLogin=true;
  bool get checkLogin=>_checkLogin;
  AccessToken?_accessToken;
  AccessToken? get accessToken=>_accessToken;
  bool _loginWithFacebook=false;
  bool get loginWithFacebook=>_loginWithFacebook;
  // late UserModel _userModel;
  // UserModel get userModel=>_userModel;

  Future<ResponseModel> registration(SignUpModel signUpModel)async{
    _isLoading=true;
    update();
    ResponseModel responseModel;
    Response response=await  authRepo.registration(signUpModel);
    if(response.statusCode==200){
        authRepo.saveToken(response.body['token']);
        responseModel=ResponseModel(true,response.body['token'] );
    }else{

      responseModel=ResponseModel(false,response.statusText!);
    }
    _isLoading=false;
    update();
    return responseModel;

  }

  Future<ResponseModel> login(String phone,String password)async{
    _isLoading=true;
    update();

    Response response=await  authRepo.login(phone,password);
    ResponseModel responseModel;
    if(response.statusCode==200){
      authRepo.saveToken(response.body['token']);
      responseModel=ResponseModel(true,response.body['token'] );
    }else{
      print('reeeeeeeeeeesponse'+response.statusText!);
      responseModel=ResponseModel(false,response.statusText!);

    }
    _isLoading=false;
    update();
    return responseModel;

  }

  Future<ResponseModel> facebookLogin() async {
    ResponseModel responseModel;
    final accessToken=await FacebookAuth.instance.accessToken;
    _checkLogin=false;
    _isLoading=true;
    update();
    if(accessToken!=null){
      _loginWithFacebook=true;
      print(accessToken.toJson());
      _userData=await FacebookAuth.instance.getUserData();
      _accessToken=accessToken;
      responseModel= ResponseModel(true,'already Login');
    }else{

      responseModel= ResponseModel(false,'Login failed');
      FacebookAuth.instance.login(
          permissions: ['public_profile','email']
      ).then((value) {
        FacebookAuth.instance.getUserData().then((userData) async{
          _userData=userData;
          _userModel=UserModel.fromJson(userData);           //second solution
        //  authRepo.saveToken(userData.);

          //_userModel=UserModel.fromJson(userData);
        } );
        _accessToken=value.accessToken;
        _loginWithFacebook=true;
        authRepo.saveToken(_accessToken!.token);
        responseModel=ResponseModel(true,'Login success');
      }).catchError((error){
        print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&%%%%%%%%%%%%%%%%%%%%%%'+error.toString());

        responseModel=ResponseModel(false,'Login failed');
      });
      print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&%%%%%%%%%%%%%%%%%%%%%%'+_userModel.toString());

    }

    _isLoading=false;
    update();
    return responseModel;
  }

  void facebookLogout()async{
    await FacebookAuth.instance.logOut();
    print('facebook logout done');
    _accessToken=null;
    _userData={};
    update();
  }

  void savePhoneAndPassword(String phone,String password){
    authRepo.savePhoneAndPassword(phone, password);
  }

  bool isUserLogin(){
    return authRepo.isUserLogin();
  }

  bool clearSharedData(){
    return authRepo.clearSharedData();
  }

}