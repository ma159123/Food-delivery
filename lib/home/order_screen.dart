
import 'package:flutter/material.dart';
import 'package:food_delivery/base/no_data_page.dart';
import 'package:food_delivery/data/controller/order_controller.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/widgets/app_icon.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/dimensions.dart';
import 'package:get/get.dart';
class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var getAllOrdersList = Get.find<OrderController>().allOrders ?? [];
   // Map<String, dynamic> cartItemPerOrder = {};
    // if (getAllOrdersList.isNotEmpty) {
    //   for (int i = 0; i < getAllOrdersList.length; i++) {
    //     if (cartItemPerOrder.containsKey(getAllOrdersList[i].id)) {
    //       cartItemPerOrder.update(
    //           getAllOrdersList[i].id.toString(), (value) => ++value);
    //     } else {
    //       cartItemPerOrder.putIfAbsent(
    //           getAllOrdersList[i].id.toString(), () => 1);
    //     }
    //   }
    // }

    int listCounter = 0;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: Dimensions.height20 * 4,
              color: AppColors.mainColor,
              padding: EdgeInsets.only(top: Dimensions.height20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BigText(
                    'Orders',
                    color: Colors.white,
                  ),
                  AppIcon(
                    icon: Icons.reorder,
                    iconColor: AppColors.mainColor,
                    backgroundColor: Colors.yellowAccent,
                  ),
                ],
              ),
            ),
            GetBuilder<OrderController>(
              builder: (orderController) {
                return getAllOrdersList.isNotEmpty
                    ? Expanded(
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
                                for (int i = 0;
                                    i < getAllOrdersList.length;
                                    i++)
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  '#order ID',
                                                ),
                                                SizedBox(
                                                  width: Dimensions.width10 / 2,
                                                ),
                                                Text(getAllOrdersList[i]
                                                    .id
                                                    .toString()),
                                              ],
                                            ),
                                            Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColors.mainColor,
                                                      borderRadius: BorderRadius
                                                          .circular(Dimensions
                                                                  .radius20 /
                                                              4),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                Dimensions
                                                                    .width10,
                                                            vertical: Dimensions
                                                                    .width10 /
                                                                2),
                                                    child: const Text(
                                                      'pending',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        Dimensions.height10 / 2,
                                                  ),
                                                  InkWell(
                                                    onTap: () => null,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  Dimensions
                                                                      .width10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius
                                                            .circular(Dimensions
                                                                    .radius20 /
                                                                4),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                      child: Container(
                                                          margin: EdgeInsets
                                                              .all(Dimensions
                                                                      .height10 /
                                                                  2),
                                                          child: const Text(
                                                              'Track order')),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    margin: EdgeInsets.only(
                                        bottom: Dimensions.height10),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: NoDataPage(
                          text: 'You did not buy any thing so far !',
                          imgPath: 'assets/image/empty_box.png',
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
