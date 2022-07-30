import 'package:food_delivery/data/controller/address_controller.dart';
import 'package:food_delivery/data/controller/auth_controller.dart';
import 'package:food_delivery/data/controller/cart_controller.dart';
import 'package:food_delivery/data/controller/order_controller.dart';
import 'package:food_delivery/data/repo/address_repo.dart';
import 'package:food_delivery/data/repo/auth_repo.dart';
import 'package:food_delivery/data/repo/cart_repo.dart';
import 'package:food_delivery/data/repo/order_repo.dart';
import 'package:food_delivery/utils/constants/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/Api/api_client.dart';
import '../data/controller/popular_product_controller.dart';
import '../data/controller/recommended_product_controller.dart';
import '../data/controller/user_controller.dart';
import '../data/repo/popular_data_repo.dart';
import '../data/repo/recommended_products_repo.dart';
import '../data/repo/user_repo.dart';


// get.put()  >> بيعمل instance من الكونترولير و بيحطه في الميموري
// get.lazyPut()  >> نفس اللي فاتت لكن هنا مش بتحملها على الميموري تلقاءي لكن انا اللي باديها الامر عن طريق (get.find())
// get.putAsync()  >> بستعملها لما بقرا داتا قبل ما اعمل نسخة من الكونترولير والداتا دي بتحتاج وقت
//get.create()   >> كل مرة بعمل get.find بيعمل نسخة جديدة من الكونترولير
// لكن التانيين كل ما اعملها بتتنفذ على نفس النسخة يعني كل النسخ بتكون فيها نفس القيم
Future<void> init()async{
  final sharedPreferences=await SharedPreferences.getInstance();
//api client
  Get.lazyPut (()=>ApiClient(appBaseUrl: AppConstants.BASE_URL, sharedPreferences: sharedPreferences));

  //repos
  Get.lazyPut(()=>sharedPreferences);
  Get.lazyPut(()=>PopularProductRepo(apiClient:Get.find()));
  Get.lazyPut(()=>RecommendedProductRepo(apiClient:Get.find()));
  Get.lazyPut(() => CartRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => AuthRepo(sharedPreferences: sharedPreferences, apiClient: Get.find()));
  Get.lazyPut(() => UserRepo(apiClient: Get.find()));
  Get.lazyPut(() => AddressRepo(apiClient: Get.find(), sharedPreferences: sharedPreferences));
  Get.lazyPut(() => OrderRepo(apiClient: Get.find()));

//controllers
  Get.lazyPut(() => AuthController(authRepo:Get.find()));
  Get.lazyPut(() => UserController(userRepo:Get.find()));
  Get.lazyPut (()=>PopularProductController(popularDataRepo:Get.find (), ));
  Get.lazyPut (()=>RecommendedProductController(recommendedDataRepo:Get.find (), ));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
  Get.lazyPut(() => AddressController(addressRepo: Get.find()));
 Get.lazyPut(() => OrderController(orderRepo: Get.find()));

}

