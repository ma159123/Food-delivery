import 'package:flutter/material.dart';
import 'package:food_delivery/data/controller/order_controller.dart';
import 'package:food_delivery/models/order_model.dart';
import 'package:food_delivery/widgets/dimensions.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';

class ViewOrder extends StatelessWidget {
  final bool isCurrent;

  const ViewOrder({Key? key, required this.isCurrent}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: GetBuilder<OrderController>(
        builder: (orderController) {
          if (orderController.isLoading == false) {
            late List<OrderModel> orderList=[];
            if (orderController.currentOrderList.isNotEmpty) {
              orderList = isCurrent ? orderController.currentOrderList.reversed.toList() : orderController.historyOrderList.reversed.toList();
            }

           // print('order list not emptttttttttttty');
            return SizedBox(
              width: Dimensions.screenWidth,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: Dimensions.width10/2,vertical: Dimensions.height10/2),
                child: ListView.builder(
                  itemCount: orderList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => null,
                      child:Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text('#order ID',),
                                    SizedBox(width: Dimensions.width10/2,),
                                    Text(orderList[index].id.toString()),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.mainColor,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radius20 / 4),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.width10,vertical: Dimensions.width10/2),
                                      child: Text(
                                        '${orderList[index].orderStatus}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Dimensions.height10 / 2,
                                    ),
                                    InkWell(
                                      onTap: () => null,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(Dimensions.radius20 / 4),
                                          border: Border.all(width: 1,color: Theme.of(context).primaryColor),
                                        ),
                                        child: Container(
                                            margin: EdgeInsets.all(Dimensions.height10/2),
                                            child: const Text('Track order')),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Dimensions.height10,),
                        ],
                      ),
                    );
                  },

                ),
              ),
            );
          }else{
           // print('order list loooooding');
            return const Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }
}
