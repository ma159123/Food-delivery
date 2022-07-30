import 'package:flutter/material.dart';
import 'package:food_delivery/base/common_text_button.dart';
import 'package:food_delivery/base/no_data_page.dart';
import 'package:food_delivery/base/show_custom_snackbar.dart';
import 'package:food_delivery/data/controller/address_controller.dart';
import 'package:food_delivery/data/controller/auth_controller.dart';
import 'package:food_delivery/data/controller/cart_controller.dart';
import 'package:food_delivery/data/controller/order_controller.dart';
import 'package:food_delivery/data/controller/popular_product_controller.dart';
import 'package:food_delivery/data/controller/user_controller.dart';
import 'package:food_delivery/home/delivery_options.dart';
import 'package:food_delivery/home/main_food_page.dart';
import 'package:food_delivery/home/stripe_payment.dart';
import 'package:food_delivery/models/place_order_model.dart';
import 'package:food_delivery/utils/constants/app_constants.dart';
import 'package:food_delivery/widgets/app_text_field.dart';
import 'package:food_delivery/widgets/small_text.dart';
import 'package:get/get.dart';
import '../data/controller/recommended_product_controller.dart';
import '../helper/route_helper.dart';
import '../utils/colors.dart';
import '../widgets/app_icon.dart';
import '../widgets/big_text.dart';
import '../widgets/dimensions.dart';
import 'payment_option_button.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _noteController=TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: Dimensions.height20 * 3,
            left: Dimensions.width20,
            right: Dimensions.width20,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: AppIcon(
                      icon: Icons.arrow_back_ios,
                      iconColor: Colors.white,
                      backgroundColor: AppColors.mainColor,
                      iconSize: Dimensions.iconSize24,
                    ),
                    onTap: () {
                      // Get.to(page)
                    },
                  ),
                  SizedBox(
                    width: Dimensions.width20 * 5,
                  ),
                  GestureDetector(
                    child: AppIcon(
                      icon: Icons.home_outlined,
                      iconColor: Colors.white,
                      backgroundColor: AppColors.mainColor,
                      iconSize: Dimensions.iconSize24,
                    ),
                    onTap: () {
                      Get.to(const MainFoodPage());
                    },
                  ),
                  AppIcon(
                    icon: Icons.shopping_cart_outlined,
                    iconColor: Colors.white,
                    backgroundColor: AppColors.mainColor,
                    iconSize: Dimensions.iconSize24,
                  ),
                ]),
          ),
          GetBuilder<CartController>(
            builder: (cartController) {
              return Positioned(
                  top: Dimensions.height20 * 5,
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  bottom: 0,
                  child: cartController.getCartItems.isNotEmpty
                      ? Container(
                          margin: EdgeInsets.only(top: Dimensions.height15),
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: GetBuilder<CartController>(
                              builder: (controller) {
                                var _cartList = controller.getCartItems;
                                return ListView.builder(
                                    itemCount: _cartList.length,
                                    itemBuilder: (_, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          var popularProduct = Get.find<
                                                  PopularProductController>()
                                              .popularProductList
                                              .indexOf(
                                                  _cartList[index].product);
                                          if (popularProduct >= 0) {
                                            Get.toNamed(AppRoute.getPopularFood(
                                                popularProduct, 'cartPage'));
                                          } else {
                                            var recommendedProduct = Get.find<
                                                    RecommendedProductController>()
                                                .recommendedProductList
                                                .indexOf(
                                                    _cartList[index].product);

                                            if (recommendedProduct < 0) {
                                              Get.snackbar(
                                                "History product",
                                                "product review is not available",
                                                backgroundColor:
                                                    AppColors.yellowColor,
                                                colorText: Colors.white,
                                              );
                                            } else {
                                              Get.toNamed(
                                                  AppRoute.getRecommendedFood(
                                                      recommendedProduct,
                                                      'cartPage'));
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: double.maxFinite,
                                          height: Dimensions.height20 * 5,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: Dimensions.height20 * 5,
                                                height: Dimensions.height20 * 5,
                                                margin: EdgeInsets.only(
                                                    bottom:
                                                        Dimensions.height10),
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                      AppConstants.BASE_URL +
                                                          AppConstants
                                                              .UPLOAD_URL +
                                                          controller
                                                              .getCartItems[
                                                                  index]
                                                              .img!,
                                                    ),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions.radius20),
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(
                                                width: Dimensions.width10,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height:
                                                      Dimensions.height20 * 5,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      BigText(
                                                        controller
                                                            .getCartItems[index]
                                                            .name!,
                                                        color: Colors.black54,
                                                      ),
                                                      SmallText('spicy'),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          BigText(
                                                            "\$ ${controller.getCartItems[index].price}",
                                                            color: Colors
                                                                .redAccent,
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                              top: Dimensions
                                                                  .height10,
                                                              bottom: Dimensions
                                                                  .height10,
                                                              left: Dimensions
                                                                  .width10,
                                                              right: Dimensions
                                                                  .width10,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        Dimensions
                                                                            .radius20),
                                                                color: Colors
                                                                    .white),
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  child: Icon(
                                                                    Icons
                                                                        .remove,
                                                                    color: AppColors
                                                                        .signColor,
                                                                  ),
                                                                  onTap: () {
                                                                    controller.addItem(
                                                                        _cartList[index]
                                                                            .product!,
                                                                        -1);
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                  width: Dimensions
                                                                          .width10 /
                                                                      2,
                                                                ),
                                                                BigText(
                                                                    '${controller.getCartItems[index].quantity}'),
                                                                //popularProduct.inCartItems.toString()),
                                                                SizedBox(
                                                                  width: Dimensions
                                                                          .width10 /
                                                                      2,
                                                                ),
                                                                GestureDetector(
                                                                  child: Icon(
                                                                    Icons.add,
                                                                    color: AppColors
                                                                        .signColor,
                                                                  ),
                                                                  onTap: () {
                                                                    controller.addItem(
                                                                        _cartList[index]
                                                                            .product!,
                                                                        1);
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                          ),
                        )
                      : NoDataPage(text: 'No product found'));
            },
          ),
        ],
      ),
      bottomNavigationBar: GetBuilder<OrderController>(

        builder: ( orderController) {
          _noteController.text=orderController.foodNote;
          return  GetBuilder<CartController>(
            builder: (cartController) {
              return Container(
                height: Dimensions.bottomHeightBar + 90,
                padding: EdgeInsets.only(
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    top: Dimensions.height30,
                    bottom: Dimensions.height30),
                decoration: BoxDecoration(
                    color: AppColors.buttonBackgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.radius20 * 2),
                        topRight: Radius.circular(Dimensions.radius20 * 2))),
                child: GetBuilder<CartController>(
                  builder: (cartController) {
                    return cartController.getCartItems.isNotEmpty
                        ? Column(
                      children: [
                        InkWell(
                          onTap: () => showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (_) {
                                return Column(
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Container(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.9,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(
                                                  Dimensions.radius20),
                                              topLeft: Radius.circular(
                                                  Dimensions.radius20),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: Dimensions.width20,
                                                    right: Dimensions.width20,
                                                    top: Dimensions.height20,

                                                ),
                                                height: Dimensions.height10 * 51,
                                                child: Column(
                                                  children:  [
                                                    const PaymentOptionButton(
                                                      icon: Icons.money,
                                                      index: 0,
                                                      title:
                                                      'cash on delivery',
                                                      subTitle:
                                                      'you pay after getting the delivery',
                                                    ),
                                                    SizedBox(height: Dimensions.height10,),
                                                    const PaymentOptionButton(
                                                      icon: Icons.paypal,
                                                      index: 1,
                                                      title: 'Digital payment',
                                                      subTitle:
                                                      'safer and faster way to pay',
                                                    ),
                                                    SizedBox(height: Dimensions.height20,),
                                                    Text('Delivery options',style: TextStyle(
                                                      fontSize: Dimensions.font16+4,
                                                    ),),
                                                    SizedBox(height: Dimensions.height10/2,),
                                                    DeliveryOptions(
                                                      value: 'delivery',
                                                      title: 'home delivery',
                                                      amount: double.parse(Get.find<CartController>().totalAmount.toString()),
                                                      isFree: false,
                                                    ),
                                                    SizedBox(height: Dimensions.height10/2,),
                                                    const DeliveryOptions(
                                                      value: 'take away',
                                                      title: 'take away',
                                                      amount: 0.0,
                                                      isFree: false,
                                                    ),
                                                    SizedBox(height: Dimensions.height20,),
                                                    Text('Additional notes',style: TextStyle(
                                                      fontSize: Dimensions.font16+4,
                                                    ),),
                                                    SizedBox(height: Dimensions.height10/2,),
                                                    AppTextField(
                                                      textEditingController: _noteController,
                                                      hintText: '',
                                                      icon: Icons.note,
                                                      isMaxLine: true,
                                                    ),
                                                  ],
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).whenComplete(() => orderController.setFoodNote(_noteController.text.trim())),
                          child: const SizedBox(
                              width: double.maxFinite,
                              child:
                              CommonTextButton(text: 'Payment options')),
                        ),
                        SizedBox(
                          height: Dimensions.height10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                top: Dimensions.height20 / 1.2,
                                bottom: Dimensions.height20,
                                left: Dimensions.width20,
                                right: Dimensions.width20,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius20),
                                  color: Colors.white),
                              child: BigText(
                                  '\$ ' + cartController.totalAmount.toString()),
                            ),
                            GestureDetector(
                              onTap: () {
                                //   popularProduct.addItem(product);
                                if (Get.find<AuthController>()
                                    .isUserLogin()) {
                                  if (Get.find<AddressController>()
                                      .addressList
                                      .isEmpty) {
                                    Get.toNamed(AppRoute.getAddressPage());
                                  } else {
                                    payNow(Get.find<CartController>().totalAmount.toString());
                                    // var address =
                                    // Get.find<AddressController>()
                                    //     .getUserAddress();
                                    // var cart = Get.find<CartController>()
                                    //     .getCartItems;
                                    // var user =
                                    //     Get.find<UserController>().userModel;
                                    // PlaceOrderModel placeOrderModel =
                                    // PlaceOrderModel(
                                    //   cart: cart,
                                    //   orderAmount: 10.0,
                                    //   orderNote: orderController.foodNote,
                                    //   address: address.address,
                                    //   latitude: address.latitude,
                                    //   longitude: address.longitude,
                                    //   contactPersonName: user.name,
                                    //   contactPersonNumber: user.phone,
                                    //   scheduledAt: '',
                                    //   distance: 10.0, orderType: orderController.orderType , paymentMethod: orderController.paymentIndex==0?'cash_on_delivery':'digital_payment',
                                    // );
                                    // Get.find<OrderController>().placeOrder(
                                    //     placeOrderModel, _callBack);
                                    // Get.toNamed(AppRoute.getInitialPage());
                                  }
                                } else {
                                  Get.toNamed(AppRoute.getLoginPage());
                                }
                              },
                              child: const CommonTextButton(
                                text: 'Check out',
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                        : Container();
                  },
                ),
              );
            },
          );
        },

      ),
    );
  }

  // void _callBack(bool isSuccess, String message, String orderId) {
  //   if (isSuccess) {
  //     Get.find<CartController>().clear();
  //     Get.find<CartController>().removeCartSharedPreference();
  //     Get.find<CartController>().addToHistoryList();
  //     if(Get.find<OrderController>().paymentIndex==0){
  //       Get.offNamed(AppRoute.getOrderSuccessPage(orderId, 'success'));
  //     }else{
  //       Get.toNamed(AppRoute.getPaymentPage(
  //           orderId, Get.find<UserController>().userModel.id));
  //     }
  //
  //   } else {
  //     print('callBack errrrrrrrror');
  //     showCustomSnackBar(message);
  //   }
  // }

  void payNow(String amount)async{
    var response=await StripeServices.payNowHandler(amount: amount, currency: 'USD');
    if(response.success){
      showCustomSnackBar(response.message);
      Get.find<CartController>().addToHistoryList();
    }else{
      showCustomSnackBar(response.message);
    }
    print('response message :${response.message}');
  }
}
