import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_app_bar.dart';
import 'package:food_delivery/data/controller/auth_controller.dart';
import 'package:food_delivery/data/controller/order_controller.dart';
import 'package:food_delivery/home/view_order.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/widgets/dimensions.dart';
import 'package:get/get.dart';

import '../helper/route_helper.dart';
import '../widgets/big_text.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with TickerProviderStateMixin {

  late TabController _tabController;
  late bool _isLoggedIn;
  bool first=true;

  @override

  void initState() {
    if(first){
      first=false;
      // TODO: implement initState
      super.initState();
      _isLoggedIn=Get.find<AuthController>().isUserLogin();
      if(_isLoggedIn){
        _tabController =TabController(length: 2, vsync: this);
        Get.find<OrderController>().getOrderList();
        //print('getttttttttttting order list is 200');
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const CustomAppBar(title: 'Order Page', backButtonExist: false, onBackPressed: null,),
      body:_isLoggedIn? Column(
        children: [
          SizedBox(
            width: Dimensions.screenWidth,
            child: TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              indicatorWeight: 3,
              labelColor: AppColors.mainColor,
              unselectedLabelColor: AppColors.yellowColor,
              controller: _tabController,
              tabs: const [
                Tab(text: 'Current',),
                Tab(text: 'History',),
              ],
            ),
          ),
           Expanded(
             child: TabBarView(
                 controller: _tabController,
                 children:const [
                   ViewOrder(isCurrent: true),
                   ViewOrder(isCurrent: false),
                 ] ,
             ),
           ),
        ],
      ):Container(
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
      ),
    );
  }
}
