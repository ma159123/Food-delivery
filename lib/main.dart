
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery/data/controller/address_controller.dart';
import 'package:food_delivery/data/controller/auth_controller.dart';
import 'package:food_delivery/data/controller/cart_controller.dart';
import 'package:food_delivery/data/controller/popular_product_controller.dart';
import 'package:food_delivery/data/controller/user_controller.dart';
import 'package:food_delivery/helper/route_helper.dart';
import 'package:food_delivery/home/stripe_payment.dart';
import 'package:food_delivery/models/address_model.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:get/get.dart';
import 'data/controller/order_controller.dart';
import 'data/controller/recommended_product_controller.dart';
import 'helper/dependencies.dart' as dep;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await dep.init();
Stripe.publishableKey='pk_test_51LPWpBEu20JFnbILgPFSky2JOKTiC3G4V8dlVk9JL2OPWvAdy7lQZyywhWdZVaOUYDPWn3kl5cS5gpJ20f6rg8PU00WBVcvxQ6';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

   //Get.find<CartController>().getStorageItems();
    return GetBuilder<CartController>(
      builder: (cartController){
        cartController.getStorageItems();
        return  GetBuilder<PopularProductController>(
          builder: (_) {
            return  GetBuilder<RecommendedProductController>(
              builder: (_){
                return GetBuilder<UserController>(builder: (_){
                  bool isUserLoggedIn=Get.find<AuthController>().isUserLogin();
                  if(isUserLoggedIn){
                    Get.find<UserController>().getUserData();
                    Get.find<OrderController>().getOrderList();
                    //StripeServices.init();
                    //Get.find<OrderController>().getOrderList();
                    //
                  }
                  return GetBuilder<AddressController>(
                    builder: (addressController){
                      if(isUserLoggedIn){

                      //  addressController.getUserAddress();
                      }
                      return GetBuilder<AuthController>(builder: (_){
                        return GetMaterialApp(
                          title: 'Flutter Demo',
                          debugShowCheckedModeBanner: false,
                          //home:  SignInPage(),
                          initialRoute: AppRoute.getSplashPage(),
                          getPages: AppRoute.routes,
                          theme: ThemeData(
                            primaryColor: AppColors.mainColor,
                            fontFamily: 'Lato',
                          ),

                        );
                      });
                    },

                  );
                });

              },

            );
          },
        );
      },

    );
  }
}
