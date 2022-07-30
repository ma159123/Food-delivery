import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery/base/no_data_page.dart';
import 'package:food_delivery/data/controller/cart_controller.dart';
import 'package:food_delivery/models/cart_model.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/constants/app_constants.dart';
import 'package:food_delivery/widgets/app_icon.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/dimensions.dart';
import 'package:food_delivery/widgets/small_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../helper/route_helper.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var getCartHistoryList=Get.find<CartController>().getCartHistoryList();
    Map<String,dynamic> cartItemPerOrder={};
    for(int i=0;i<getCartHistoryList.length;i++){
      if(cartItemPerOrder.containsKey(getCartHistoryList[i].time)){
        cartItemPerOrder.update(getCartHistoryList[i].time!, (value) => ++value);
      }else{
        cartItemPerOrder.putIfAbsent(getCartHistoryList[i].time!, () => 1);
      }
    }
    listCartPerOrderToList(){
      return cartItemPerOrder.entries.map((e) => e.value).toList();

    }

    listCartPerTimeToList(){
      return cartItemPerOrder.entries.map((e) => e.key).toList();

    }



    List<dynamic>itemsPerOrder=listCartPerOrderToList();

    List<String> itemsPerTime=listCartPerTimeToList();
    //print('iiiiiiiiiiiiiiii'+itemsPerOrder[1].toString());

    int listCounter=0;

    Widget timeWidget(int index){
      var outputDate=DateTime.now().toString();
      if(index<getCartHistoryList.length){
        DateTime parseDate=DateFormat("yyyy-MM-dd HH:mm:ss").parse(getCartHistoryList[listCounter].time!); //دا الشكل الاساسي اللي هيتحول
        var inputDate=DateTime.parse(parseDate.toString());   //هنا هحوله
        var outputFormat=DateFormat("MM/dd/yyyy hh:mm: a "); //هحط االشكل الجديد
        outputDate=outputFormat.format(inputDate); // هنا حولته
      }

      return BigText(outputDate);
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: Dimensions.height20*4,
              color: AppColors.mainColor,
              padding:  EdgeInsets.only(top: Dimensions.height20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BigText('HistoryPage',color: Colors.white,),
                   AppIcon(icon: Icons.shopping_cart_outlined,iconColor: AppColors.mainColor,backgroundColor: Colors.yellowAccent,),
                ],
              ),

            ),
            GetBuilder<CartController>(
              builder: (cartController){
                return cartController.getCartHistoryList().isNotEmpty? Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: Dimensions.height20,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                    ),
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView(
                        children: [
                          for(int i=0;i<itemsPerOrder.length;i++)
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  timeWidget(listCounter),

                                  SizedBox(height:Dimensions.height10*1.5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [
                                      Wrap(
                                        direction: Axis.horizontal,
                                        children: List.generate(itemsPerOrder[i], (index) {
                                          if(listCounter<getCartHistoryList.length){
                                            listCounter++;
                                          }
                                          return index<=2? Container(
                                            height: Dimensions.height20*3.5,
                                            width: Dimensions.width40*1.7,
                                            margin: EdgeInsets.only(right: Dimensions.width10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(AppConstants.BASE_URL+AppConstants.UPLOAD_URL+getCartHistoryList[listCounter-1].img!),
                                              ),
                                            ),
                                          ): Container();
                                        }),
                                      ),
                                      Container(

                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SmallText('items',color: AppColors.titleColor,),
                                            BigText(itemsPerOrder[i].toString()+' Items',color: AppColors.titleColor,),
                                            GestureDetector(
                                              onTap: (){
                                                var orderTime=listCartPerTimeToList();
                                                Map<int,CartModel>moreOrders={};
                                                for(int j=0 ; j<getCartHistoryList.length;j++){
                                                  if(getCartHistoryList[j].time==orderTime[i]){
                                                    moreOrders.putIfAbsent(getCartHistoryList[j].id!, () => CartModel.fromJson(jsonDecode(jsonEncode(getCartHistoryList[j]))));
                                                  }
                                                }
                                                Get.find<CartController>().addOrderItems=moreOrders;
                                                Get.find<CartController>().addToCartList();
                                                Get.toNamed(AppRoute.getCartPage());
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: Dimensions.width10,vertical: Dimensions.height10/2),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(Dimensions.radius15/3),
                                                  border: Border.all(color: AppColors.mainColor,width: 1),
                                                ),
                                                child: SmallText('one more',color: AppColors.mainColor,),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.only(bottom: Dimensions.height10),
                            ),
                        ],
                      ),
                    ),
                  ),
                ):Container(
                    height: MediaQuery.of(context).size.height/1.5,
                    child: NoDataPage(text: 'You did not buy any thing so far !',
                      imgPath: 'assets/image/empty_box.png',),);
              },
            ),
          ],
        ),

      ),
    );
  }
}
