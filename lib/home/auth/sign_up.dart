import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:food_delivery/base/show_custom_snackbar.dart';
import 'package:food_delivery/data/controller/auth_controller.dart';
import 'package:food_delivery/helper/route_helper.dart';
import 'package:food_delivery/models/sign_up_model.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/dimensions.dart';
import 'package:get/get.dart';

import '../../widgets/app_text_field.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();



  void _registration(AuthController authController){
    String name=nameController.text.trim();
    String phone=phoneController.text.trim();
    String email=emailController.text.trim();
    String password=passwordController.text.trim();

    if(name.isEmpty){
     showCustomSnackBar('Type in your name',title: 'Name' );
    }else if(phone.isEmpty){
      showCustomSnackBar('Type in your phone',title: 'Phone' );
    }else if(email.isEmpty){
      showCustomSnackBar('Type in your email',title: 'Email' );
    }
    // else if(GetUtils.isEmail(email)){
    //   showCustomSnackBar('Type in valid email address',title: 'Email' );
    // }
    else if(password.isEmpty){
      showCustomSnackBar('Type in your password',title: 'Password' );
    }else{
      //showCustomSnackBar('All went well',title: 'Perfect' ,isError: false);
     SignUpModel signUpModel= SignUpModel(password: password, name: name, phone: phone, email: email);
     authController.registration(signUpModel).then((value) {
       if(value.isSuccess){
         print('registration success');
         showCustomSnackBar('registration success',isError: false);
        Get.toNamed(AppRoute.getLoginPage());
       }else{
         showCustomSnackBar('registration failed');
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
            //physics:ScrollPhysics ,
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
                AppTextField(
                  textEditingController: emailController,
                  icon: Icons.email,
                  hintText: 'Email',
                ),
                SizedBox(
                  height: Dimensions.height20,
                ),
                AppTextField(
                  isObsecure: true,
                  textEditingController: passwordController,
                  icon: Icons.password,
                  hintText: 'Password',
                ),
                SizedBox(
                  height: Dimensions.height20,
                ),
                AppTextField(
                  textEditingController: nameController,
                  icon: Icons.person,
                  hintText: 'Name',
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
                  height: Dimensions.height30,
                ),
                GestureDetector(
                  onTap: (){
                    _registration(authController);
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
                        'Sign up',
                        size: Dimensions.font16 * 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                RichText(
                  text: TextSpan(
                    recognizer: TapGestureRecognizer()..onTap=()=>Get.back(),
                    text: 'Have an account already?',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: Dimensions.font16,
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimensions.screenHeight * 0.05,
                ),
                // RichText(
                //   text: TextSpan(
                //     text: 'Sign up using one of the following methods',
                //     style: TextStyle(
                //       color: Colors.grey[500],
                //       fontSize: Dimensions.font16,
                //     ),
                //   ),
                // ),
                // Wrap(
                //   children: List.generate(3, (index) => Padding(padding: const EdgeInsets.all(8.0),
                //     child: InkWell(
                //       onTap: ()async{
                //         if(index==0){
                //           authController.facebookLogin();
                //           // FacebookAuth.instance.login(
                //           //   permissions: ['public_profile','email']
                //           // ).then((value) {
                //           //   FacebookAuth.instance.getUserData().then((userData) async{
                //           //     _isLoggedIn=true;
                //           //     _userData=userData;
                //           //   } );
                //           // });
                //         }
                //       },
                //       child: CircleAvatar(
                //         radius: Dimensions.radius20,
                //         backgroundImage: AssetImage(
                //             'assets/image/'+signUpImages[index]
                //         ),
                //       ),
                //     ),
                //   ),),
                // ),
              ],
            ),
          ):const Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}
