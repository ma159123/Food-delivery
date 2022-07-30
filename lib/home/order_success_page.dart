import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/widgets/custom_button.dart';
import 'package:food_delivery/widgets/dimensions.dart';
import 'package:get/get.dart';

import '../helper/route_helper.dart';

class OrderSuccessPage extends StatelessWidget {
  final String orderId;
  final int status;

  const OrderSuccessPage(
      {Key? key, required this.orderId, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (status == 0) {
      Future.delayed(Duration(seconds: 1), () {});
    }
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: Dimensions.screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                status == 1
                    ? 'assets/image/checked.png'
                    : 'assets/image/warning.png',
                width: Dimensions.width20 * 5,
                height: Dimensions.height20 * 5,
              ),
              SizedBox(
                height: Dimensions.height45,
              ),
              Text(
                status == 1 ? 'The order placed successfully' : 'Order failed',
                style: TextStyle(fontSize: Dimensions.font16),
              ),
              SizedBox(
                height: Dimensions.height20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.height20,
                    vertical: Dimensions.height20),
                child: Text(status==1?'Successful order':'Failed order',
                    style: TextStyle(fontSize: Dimensions.font16,
                      color: Theme.of(context).disabledColor,
                    ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: Dimensions.height30,),
              Padding(padding: EdgeInsets.all(Dimensions.height20),
              child: CustomButton(buttonText: 'Back to home',
              onPressed: (){
                Get.offNamed(AppRoute.getInitialPage());
              },
              ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
