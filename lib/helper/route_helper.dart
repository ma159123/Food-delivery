import 'package:food_delivery/home/add_address_page.dart';
import 'package:food_delivery/home/auth/sign_in.dart';
import 'package:food_delivery/home/cart.dart';
import 'package:food_delivery/home/home_page.dart';
import 'package:food_delivery/home/payment_page.dart';
import 'package:food_delivery/home/popular_food_details.dart';
import 'package:food_delivery/home/splash.dart';
import 'package:food_delivery/models/order_model.dart';
import 'package:get/get.dart';

import '../home/order_success_page.dart';
import '../home/pick_address_map.dart';
import '../home/recommanded_food_details.dart';

class AppRoute {
  static const String initialRoute = '/';
  static const String splashRoute = '/splash_page';
  static const String popularFood = '/popular_food';
  static const String recommendedFood = '/recommended_food';
  static const String cartPage = '/cart_page';
  static const String loginPage = '/login_page';
  static const String addressPage = '/address_page';
  static const String pickAddressPage = '/pick_address_page';
  static const String payment = '/payment';
  static const String orderSuccess = '/order_success';

  static String getPopularFood(int pageId, String page) =>
      '$popularFood?pageId=$pageId&page=$page';

  static String getCartPage() => cartPage;

  static String getLoginPage() => loginPage;

  static String getInitialPage() => initialRoute;

  static String getSplashPage() => splashRoute;

  static String getAddressPage({fromPickAddressPage}) => addressPage;

  static String getPickAddressPage(
          {fromSignupPage, googleMapController, fromAddressPage}) =>
      pickAddressPage;

  static String getRecommendedFood(int pageId, String page) =>
      '$recommendedFood?pageId=$pageId&page=$page';

  static String getPaymentPage(String id,int userId) => '$payment?id=$id&userId=$userId';

  static String getOrderSuccessPage(String orderId,String status) => '$orderSuccess?id=$orderId&status=$status';

  static List<GetPage> routes = [
    GetPage(
      name: splashRoute,
      page: () {
        return const SplashScreen();
      },
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: loginPage,
      page: () {
        return SignInPage();
      },
      transition: Transition.fade,
    ),
    GetPage(
      name: initialRoute,
      page: () {
        return const HomePage();
      },
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: pickAddressPage,
      page: () {
        PickAddressMap _pickAddress = Get.arguments;
        return _pickAddress;
      },
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: popularFood,
      page: () {
        var pageId = Get.parameters['pageId'];
        var page = Get.parameters['page'];
        return PopularFoodDetails(pageId: int.parse(pageId!), page: page!);
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: recommendedFood,
      page: () {
        var pageId = Get.parameters['pageId'];
        var page = Get.parameters['page'];
        return RecommendedFoodDetails(pageId: int.parse(pageId!), page: page!);
      },
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: cartPage,
      page: () {
        return  CartPage();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: addressPage,
      page: () {
        AddAddressPage _addAddressPage=Get.arguments;
        return _addAddressPage;
      },
      transition: Transition.fadeIn,
    ),

    GetPage(
        name: payment,
        page: () {
          return PaymentPage(
            orderModel: OrderModel(
              userId: int.parse(Get.parameters['userId']!),
              id: int.parse(Get.parameters['id']!),
            ),
          );
        }),

     GetPage(name: orderSuccess, page: ()=>OrderSuccessPage(
       status: Get.parameters['status'].toString().contains('success')?1:0 ,
       orderId: Get.parameters['id']!,

     )),
  ];
}
