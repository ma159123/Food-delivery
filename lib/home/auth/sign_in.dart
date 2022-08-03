import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/home/auth/sign_up.dart';
import 'package:food_delivery/models/response_model.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/dimensions.dart';
import 'package:get/get.dart';

import '../../base/show_custom_snackbar.dart';
import '../../data/controller/auth_controller.dart';
import '../../helper/route_helper.dart';
import '../../widgets/app_text_field.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);

  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  bool _isLoggedIn=false;
  Map _userData={};

  List<String >signUpImages=[
    'f.png',
    't.png',
    'g.png',
  ];

  void _login(AuthController authController){
    String phone=phoneController.text.trim();
    String password=passwordController.text.trim();

    if(phone.isEmpty){
      showCustomSnackBar('Type in your phone',title: 'Phone' );
    }
    // else if(GetUtils.isEmail(email)){
    //   showCustomSnackBar('Type in valid email address',title: 'Email' );
    // }
    else if(password.isEmpty){
      showCustomSnackBar('Type in your password',title: 'Password' );
    }else{
     // showCustomSnackBar('All went well',title: 'Perfect' ,isError: false);

      authController.login(phone,password).then((value) {
        if(value.isSuccess){
          print('login success');
          showCustomSnackBar('Login success',isError: false,title: 'Login');
          Get.toNamed(AppRoute.getInitialPage());

        }else{
          showCustomSnackBar('Login failed');
        }
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(
        builder: (authController){
          return !authController.isLoading? SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: Dimensions.screenHeight * 0.05,
                ),
                Container(
                  height: Dimensions.screenHeight * 0.25,
                  child: const Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 80,
                      backgroundImage: AssetImage('assets/image/logo part 1.png'),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: Dimensions.width20),
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 4.1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Sign into your account',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 1.3,
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      AppTextField(
                        textEditingController: phoneController,
                        icon: Icons.phone,
                        hintText: 'Phone',
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      AppTextField(
                        isObsecure: true,
                        textEditingController: passwordController,
                        icon: Icons.password_sharp,
                        hintText: 'Password',
                      ),
                      SizedBox(
                        height: Dimensions.height30,
                      ),
                      Row(
                        children: [
                          Expanded(child: Container()),
                          RichText(
                            text: TextSpan(
                              text: 'Sign into your account',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: Dimensions.font16,
                              ),
                            ),
                          ),
                          SizedBox(width: Dimensions.width20,),
                        ],
                      ),
                      SizedBox(
                        height: Dimensions.height30,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: (){
                            _login(authController);
                          },
                          child: Container(
                            width: Dimensions.screenWidth / 2,
                            height: Dimensions.screenHeight / 13,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radius20),
                              color: AppColors.mainColor,
                            ),
                            child: Center(
                              child: BigText(
                                'Sign in',
                                size: Dimensions.font16 * 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.back(),
                            text: 'Have\'nt an account?',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: Dimensions.font16,
                            ),
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Get.to(() => SignUpPage(),transition: Transition.fade),
                                text: 'Create',
                                style: TextStyle(
                                  color: AppColors.mainBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Dimensions.font16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Sign up using one of the following methods',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: Dimensions.font16,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Wrap(
                          children: List.generate(3, (index) => Padding(padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: ()async{
                                if(index==0){
                               ResponseModel responseModel=await authController.facebookLogin();
                               if(responseModel.isSuccess==true){
                                 Get.toNamed(AppRoute.getInitialPage());
                                 //showCustomSnackBar('Login success',isError: false,title: 'Login');
                               }else{
                                // showCustomSnackBar('Login failed',isError: true,title: 'Login');
                               }

                                }
                              },
                              child: CircleAvatar(
                                radius: Dimensions.radius20,
                                backgroundImage: AssetImage(
                                    'assets/image/'+signUpImages[index]
                                ),
                              ),
                            ),
                          ),),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ):const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
