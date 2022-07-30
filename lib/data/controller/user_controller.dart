import 'package:food_delivery/data/repo/user_repo.dart';
import 'package:food_delivery/models/user_model.dart';
import 'package:get/get.dart';

import '../../models/response_model.dart';

class UserController extends GetxController {
   UserRepo userRepo;

  UserController({required this.userRepo});

   UserModel? _userModel;
  UserModel? get userModel=>_userModel;

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  Future<ResponseModel> getUserData() async {

    Response response = await userRepo.getUserData();
    late  ResponseModel responseModel;
    if (response.statusCode == 200) {
      _userModel=UserModel.fromJson(response.body);

      _isLoading = true;
      update();
      responseModel = ResponseModel(true, 'successfully');
    } else {
      //print('coooooode'+response.statusCode.toString());
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }
}
