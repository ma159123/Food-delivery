 import 'package:food_delivery/base/show_custom_snackbar.dart';
import 'package:get/get.dart';

import '../../helper/route_helper.dart';

class ApiChecker{
  static void checkApi(Response response){
    if(response.statusCode==401){
      Get.toNamed(AppRoute.getLoginPage());
    }else{
      showCustomSnackBar(response.statusText!);
    }
  }
 }