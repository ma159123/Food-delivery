import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:food_delivery/base/custom_app_bar.dart';
import 'package:food_delivery/data/controller/address_controller.dart';
import 'package:food_delivery/data/controller/auth_controller.dart';
import 'package:food_delivery/data/controller/cart_controller.dart';
import 'package:food_delivery/data/controller/user_controller.dart';
import 'package:food_delivery/home/add_address_page.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/widgets/account_widget.dart';
import 'package:food_delivery/widgets/app_icon.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/dimensions.dart';
import 'package:get/get.dart';
import '../helper/route_helper.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool isUserLoggedIn=Get.find<AuthController>().isUserLogin();
    print('looooooo%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%oooooooooged?'+isUserLoggedIn.toString());
    if(isUserLoggedIn){
      Get.find<UserController>().getUserData();
    }
    return GetBuilder<UserController>(
      builder: (userController){
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: 'Account Page',backButtonExist: false,onBackPressed: null),
          body:
              //  print('coooooooooooooooooonnn'+userController.toString());
               isUserLoggedIn?((Get.find<AuthController>().loginWithFacebook?Get.find<AuthController>().userData['name']=='x':userController.userModel?.name=='')?const Center(child: CircularProgressIndicator(),):Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(top: Dimensions.height20),
                child: Column(
                  children: [
                    AppIcon(
                      icon: Icons.person,
                      backgroundColor: AppColors.mainColor,
                      iconColor: Colors.white,
                      iconSize: Dimensions.height10 * 7,
                      size: Dimensions.height15 * 10 ,
                    ),
                    SizedBox(height: Dimensions.height30,),
                    //person
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            AccountWidget(
                              appIcon: AppIcon(
                                icon: Icons.person,
                                backgroundColor: AppColors.mainColor,
                                iconColor: Colors.white,
                                iconSize: Dimensions.height30 ,
                                size:Dimensions.height10 * 5,
                              ),
                              text: BigText(Get.find<AuthController>().loginWithFacebook?Get.find<AuthController>().userData['name']:userController.userModel?.name??'loading...'),
                            ),
                            SizedBox(height: Dimensions.height20,),
                            //phone
                            AccountWidget(
                              appIcon: AppIcon(
                                icon: Icons.phone,
                                backgroundColor: AppColors.yellowColor,
                                iconColor: Colors.white,
                                iconSize: Dimensions.height30 ,
                                size:Dimensions.height10 * 5,
                              ),
                              text: BigText(Get.find<AuthController>().loginWithFacebook?Get.find<AuthController>().userData['phone ']??'No phone found':userController.userModel?.phone??'loading...'),
                            ),
                            SizedBox(height: Dimensions.height20,),
                            //email
                            AccountWidget(
                              appIcon: AppIcon(
                                icon: Icons.email,
                                backgroundColor: AppColors.yellowColor,
                                iconColor: Colors.white,
                                iconSize: Dimensions.height30 ,
                                size:Dimensions.height10 * 5,
                              ),
                              text: BigText(Get.find<AuthController>().loginWithFacebook?Get.find<AuthController>().userData['email']:userController.userModel?.email??'loading...'),
                            ),
                            SizedBox(height: Dimensions.height20,),
                            //address
                            GetBuilder<AddressController>(
                              builder: (addressController){
                                if(isUserLoggedIn&&addressController.getUserAddress()?.address==null){
                                  return GestureDetector(
                                    onTap: (){
                                      Get.offNamed(AppRoute.getAddressPage(),arguments: AddAddressPage(fromPickAddressPage: false));
                                    },
                                    child: AccountWidget(
                                      appIcon: AppIcon(
                                        icon: Icons.location_on,
                                        backgroundColor: AppColors.yellowColor,
                                        iconColor: Colors.white,
                                        iconSize: Dimensions.height30 ,
                                        size:Dimensions.height10 * 5,
                                      ),
                                      text: BigText('Fill in your address'),
                                    ),
                                  );
                                }else{
                                  return GestureDetector(
                                    onTap: (){
                                      Get.offNamed(AppRoute.getAddressPage(),arguments: AddAddressPage(fromPickAddressPage: false));
                                    },
                                    child: AccountWidget(
                                      appIcon: AppIcon(
                                        icon: Icons.location_on,
                                        backgroundColor: AppColors.yellowColor,
                                        iconColor: Colors.white,
                                        iconSize: Dimensions.height30 ,
                                        size:Dimensions.height10 * 5,
                                      ),
                                      text: BigText('Your address'),
                                    ),
                                  );
                                }
                              },
                            ),
                            SizedBox(height: Dimensions.height20,),
                            //messages
                            AccountWidget(
                              appIcon: AppIcon(
                                icon: Icons.message,
                                backgroundColor: Colors.redAccent,
                                iconColor: Colors.white,
                                iconSize: Dimensions.height30 ,
                                size:Dimensions.height10 * 5,
                              ),
                              text: BigText('Messages'),
                            ),
                            SizedBox(height: Dimensions.height20,),
                            GestureDetector(
                              onTap: (){
                                if(Get.find<AuthController>().isUserLogin()){
                                  Get.find<AuthController>().clearSharedData();
                                  Get.find<CartController>().clear();
                                  Get.find<CartController>().clearCartHistory();
                                  Get.find<AddressController>().clearAddressList();
                                  Get.offNamed(AppRoute.getLoginPage());
                                }
                                Get.find<AuthController>().facebookLogout();
                              },
                              child: AccountWidget(
                                appIcon: AppIcon(
                                  icon: Icons.logout,
                                  backgroundColor: Colors.redAccent,
                                  iconColor: Colors.white,
                                  iconSize: Dimensions.height30 ,
                                  size:Dimensions.height10 * 5,
                                ),
                                text: BigText('Logout'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )):Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.maxFinite,
                      height: Dimensions.height20*8,
                      margin: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/image/signintocontinue.png'),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height20,),
                    GestureDetector(
                      onTap: (){
                        Get.toNamed(AppRoute.getLoginPage());
                      },
                      child: Container(
                        width: Dimensions.width40*7,
                        height: Dimensions.height20*3.5,
                        margin: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20),
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(Dimensions.radius15),

                        ),
                        child: Center(child: BigText('Sign in',color: Colors.white,size: Dimensions.font16*2,)),
                      ),
                    ),
                  ],
                ),
              )



        );
      },

    );
  }
}
