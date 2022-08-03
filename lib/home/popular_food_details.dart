import 'package:flutter/material.dart';
import 'package:food_delivery/data/controller/cart_controller.dart';
import 'package:food_delivery/data/controller/popular_product_controller.dart';
import 'package:food_delivery/helper/route_helper.dart';
import 'package:food_delivery/home/cart.dart';
import 'package:food_delivery/utils/constants/app_constants.dart';
import 'package:food_delivery/widgets/app_column.dart';
import 'package:food_delivery/widgets/app_icon.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';
import '../widgets/big_text.dart';
import '../widgets/dimensions.dart';
import '../widgets/expandable_text.dart';

class PopularFoodDetails extends StatelessWidget {
  int pageId;
String page;
  PopularFoodDetails({Key? key, required this.pageId, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var product =
        Get.find<PopularProductController>().popularProductList[pageId];
    Get.find<PopularProductController>()
        .initQuantity(product, Get.find<CartController>());
    print('..................${product.id}');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: Dimensions.popularFoodImgSize,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(AppConstants.BASE_URL +
                        AppConstants.UPLOAD_URL +
                        product.img!) // AssetImage
                    ),
              ),
            ),
          ),
          Positioned(
            top: Dimensions.height45,
            left: Dimensions.width20,
            right: Dimensions.width20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: AppIcon(
                    icon: Icons.arrow_back_ios,
                  ),
                  onTap: () {
                    if(page=='cartPage'){
                      Get.toNamed(AppRoute.getCartPage());
                    }else{
                      Get.toNamed(AppRoute.getInitialPage());
                    }
                  },
                ),
                GetBuilder<PopularProductController>(
                  builder: ( controller) {
                    return GestureDetector(
                      onTap: (){
                        if(   controller.totalQuantity>0){
                          Get.toNamed(AppRoute.getCartPage());
                        }
                      },
                      child: Stack(children: [
                        AppIcon(
                          icon: Icons.shopping_cart_outlined,
                        ),
                        Get.find<PopularProductController>().totalQuantity > 0
                            ? Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            child: AppIcon(
                              size: 20,
                              icon: Icons.circle,
                              iconColor: Colors.transparent,
                              backgroundColor: AppColors.mainColor,
                            ),
                            onTap: (){
                              Get.to( CartPage());
                            },
                          ),
                        )
                            : Container(),
                        Get.find<PopularProductController>().totalQuantity > 0
                            ? Positioned(
                            top: Dimensions.height10-8,
                            right: Dimensions.height10-5,
                            child: BigText(Get.find<PopularProductController>()
                                .totalQuantity
                                .toString(),color: Colors.white,size: Dimensions.font16-2,))
                            : Container(),
                      ]),
                    );
                  },

                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: Dimensions.popularFoodImgSize - 20,
            child: Container(
              padding: EdgeInsets.only(
                left: Dimensions.width20,
                right: Dimensions.width20,
                top: Dimensions.height20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimensions.radius20),
                  topLeft: Radius.circular(Dimensions.radius20),
                ),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppColumn(product.name!),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  BigText("Introduce"),
                  Expanded(
                      child: SingleChildScrollView(
                          child: ExpandableText(
                    text: product.description!,
                  ))),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: Dimensions.bottomHeightBar,
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
        child: GetBuilder<PopularProductController>(
          builder: (popularProduct) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: Dimensions.height20/1.22,
                    bottom: Dimensions.height20,
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      color: Colors.white),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Icon(
                          Icons.remove,
                          color: AppColors.signColor,
                        ),
                        onTap: () {
                          popularProduct.setQuantity(false);
                        },
                      ),
                      SizedBox(
                        width: Dimensions.width10 / 2,
                      ),
                      BigText(popularProduct.inCartItems.toString()),
                      SizedBox(
                        width: Dimensions.width10 / 2,
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.add,
                          color: AppColors.signColor,
                        ),
                        onTap: () {
                          popularProduct.setQuantity(true);
                        },
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    popularProduct.addItem(product);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      top: Dimensions.height20/1.22,
                      bottom: Dimensions.height20,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                    ),
                    child: BigText(
                      "\$ ${product.price!}|Add to cart",
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
                        color: AppColors.mainColor), // BoxDecoration
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
