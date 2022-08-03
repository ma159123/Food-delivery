import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery/base/common_text_button.dart';
import 'package:food_delivery/base/no_data_page.dart';
import 'package:food_delivery/data/controller/address_controller.dart';
import 'package:food_delivery/data/controller/auth_controller.dart';
import 'package:food_delivery/data/controller/cart_controller.dart';
import 'package:food_delivery/data/controller/order_controller.dart';
import 'package:food_delivery/data/controller/popular_product_controller.dart';
import 'package:food_delivery/home/delivery_options.dart';
import 'package:food_delivery/models/order_model.dart';
import 'package:food_delivery/utils/constants/app_constants.dart';
import 'package:food_delivery/widgets/app_text_field.dart';
import 'package:food_delivery/widgets/small_text.dart';
import 'package:get/get.dart';
import '../base/show_custom_snackbar.dart';
import '../data/controller/recommended_product_controller.dart';
import '../data/controller/user_controller.dart';
import '../helper/route_helper.dart';
import '../models/place_order_model.dart';
import '../utils/colors.dart';
import '../widgets/app_icon.dart';
import '../widgets/big_text.dart';
import '../widgets/dimensions.dart';
import 'add_address_page.dart';
import 'payment_option_button.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
   CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();




}

class _CartPageState extends State<CartPage> {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '$apiBase/payment_intents';
  static Uri paymentApiUri=Uri.parse(paymentApiUrl);
  static String secret = 'sk_test_51LPWpBEu20JFnbILdCxViZ2d4FqE28GRcPO3u1TlfSoGEqhXKo0jA4Bfy3WLcsbvA9ouqDUZ5BWtL2PZh9dREYOF00UkXZr9Wl';
  static Map<String, String> headers = {
    'Authorization': 'Bearer $secret',
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  var paymentIntent;
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
                      Get.back();
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
                      Get.toNamed(AppRoute.getInitialPage());
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
                                                color: Colors.white,
                                                height: Dimensions.height10 * 60,
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
                              onTap: ()async {
                                //   popularProduct.addItem(product);
                                if (Get.find<AuthController>()
                                    .isUserLogin()) {
                                  if (Get.find<AddressController>()
                                      .addressList
                                      .isEmpty) {
                                    Get.toNamed(AppRoute.getAddressPage(),
                                        arguments: AddAddressPage(fromPickAddressPage: false)
                                    );
                                  } else {
                                  //  Navigator.push(context, MaterialPageRoute(builder: (context)=>StripePaymentScreen()));


                                    var address =
                                    Get.find<AddressController>()
                                        .getUserAddress();
                                    var cart = Get.find<CartController>()
                                        .getCartItems;
                                    var user =
                                        Get.find<UserController>().userModel;
                                    PlaceOrderModel placeOrderModel =
                                    PlaceOrderModel(
                                      cart: cart,
                                      orderAmount: 10.0,
                                      orderNote: orderController.foodNote,
                                      address: address!.address!,
                                      latitude: address.latitude!,
                                      longitude: address.longitude!,
                                      contactPersonName: user!.name,
                                      contactPersonNumber: user.phone,
                                      scheduledAt: '',
                                      distance: 10.0, orderType: orderController.orderType , paymentMethod: orderController.paymentIndex==0?'cash_on_delivery':'digital_payment',
                                    );
                                    for(int i=0;i<cart.length;i++){
                                      OrderModel orderModel=OrderModel(
                                        id: cart[i].id!,
                                        userId: user.id,
                                      );
                                      Get.find<OrderController>().addToOrderList(orderModel);
                                    }
                                   // Get.find<OrderController>().addToOrderList(orderModel);
                                    print('alllllllllllllllllll orders: ');
                                    print( Get.find<OrderController>().allOrders![0]);
                                    if(orderController.paymentIndex==1){
                                      makePayment(currency: 'USD', amount: cartController.totalAmount.toString());
                                    }else{
                                      showCustomSnackBar('order placed successfully',isError: false,title: 'Order');
                                      Get.find<CartController>().addToHistoryList();
                                      Get.toNamed(AppRoute.getInitialPage());
                                    }

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
  //   void payNow(String amount) async {
  //     var response = await payNowHandler(amount: amount, currency: 'USD');
  //     if (response.success) {
  //       showCustomSnackBar(response.message);
  //       Get.find<CartController>().addToHistoryList();
  //     } else {
  //       showCustomSnackBar(response.message);
  //     }
  //     print('response message :${response.message}');
  //   }
  // }
  //


  Future <void> makePayment({required String amount,required String currency})async{
    try{
      paymentIntent=await createPaymentIntent(amount, currency);
      if(paymentIntent['client_secret']!=null&&paymentIntent['client_secret']!=''){
        String _intent=paymentIntent!['client_secret'];
        final billingDetails =  BillingDetails(
          name: 'Flutter Stripe',
          email: 'email@stripe.com',
          phone: '+48888000888',
          address: Address(
            city: 'Houston',
            country: 'US',
            line1: '1459  Circle Drive',
            line2: '',
            state: 'Texas',
            postalCode: '77063',
          ),
        );
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(

              paymentIntentClientSecret:_intent,
              merchantDisplayName: "Test",
              customerEphemeralKeySecret: paymentIntent['ephemeralKey'],
              customerId: paymentIntent['customer'],
              applePay: const PaymentSheetApplePay(
                merchantCountryCode: 'IN',

              ),
              googlePay: const PaymentSheetGooglePay(
                merchantCountryCode: 'IN',
                testEnv: false,
              ),
              // style: ThemeMode.dark,
              appearance:  PaymentSheetAppearance(
                primaryButton: PaymentSheetPrimaryButtonAppearance(
                  shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
                  colors: PaymentSheetPrimaryButtonTheme(
                    light: PaymentSheetPrimaryButtonThemeColors(
                      background: AppColors.mainColor,
                      text: Colors.white,
                      border: Colors.white,
                    ),
                  ),
                ),
              ),
              billingDetails: billingDetails,
            )

        );
      }else{
        print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%errror');
      }


     displayPaymentSheet();
    }catch(e){
      print('#######################################'+e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  static Future<Map<String,dynamic>> createPaymentIntent(String amount,String currency)async{
    try{
      Map<String ,dynamic> body={
        'amount':calculateAmount(amount),
        'currency':currency,
        'payment_method_types[]':'card',
      };
      var response =await http.post(paymentApiUri,
          headers: headers,body: body);
      return jsonDecode(response.body);
    }catch(error){
      print('error happened');
      rethrow;
    }
  }
  displayPaymentSheet()async{
    try{
    await  Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(clientSecret:paymentIntent!['client_secret'],
            confirmPayment: true,
          )
      );

      setState((){
        paymentIntent=null;
      });

      showCustomSnackBar('Paid successfully',isError: false,title: 'Payment');
      Get.find<CartController>().addToHistoryList();
    Get.toNamed(AppRoute.getInitialPage());

    }on StripeException catch(e){
      print(e.toString());

      showCustomSnackBar('Paid cancelled',isError: true,title: 'Payment');

      // showDialog(context: context, builder: (_)=>const AlertDialog(
      //   content: Text('Cancelled'),
      // ));
    }
  }
  static calculateAmount(String amount){
    final price=int.parse(amount)*100;
    return price.toString();
  }
}
