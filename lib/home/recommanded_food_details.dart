import 'package:flutter/material.dart';
import 'package:food_delivery/data/controller/popular_product_controller.dart';
import 'package:food_delivery/data/controller/recommended_product_controller.dart';
import 'package:food_delivery/helper/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/constants/app_constants.dart';
import 'package:food_delivery/widgets/app_icon.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/dimensions.dart';
import 'package:food_delivery/widgets/expandable_text.dart';
import 'package:get/get.dart';

import '../data/controller/cart_controller.dart';

class RecommendedFoodDetails extends StatelessWidget {
   int pageId;
   String page;
   RecommendedFoodDetails({Key? key, required this.pageId, required this.page}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var product=Get.find<RecommendedProductController>().recommendedProductList[pageId];
    Get.find<PopularProductController>()
        .initQuantity(product, Get.find<CartController>());
    return  Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: Dimensions.height70+15,
            title:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(onTap: (){
                  if(page=='cartPage'){
                    Get.toNamed(AppRoute.getCartPage());
                  }else{
                    Get.toNamed(AppRoute.getInitialPage());
                  }

                },child: AppIcon(icon: Icons.clear,iconSize: Dimensions.iconSize16,)),
                GetBuilder<PopularProductController>(
                  builder: ( controller) {
                    return GestureDetector(
                      onTap: (){
                        if(   Get.find<PopularProductController>().totalQuantity>0) {
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
                          child: AppIcon(
                            size: 20,
                            icon: Icons.circle,
                            iconColor: Colors.transparent,
                            backgroundColor: AppColors.mainColor,
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
            ) ,
            bottom: PreferredSize(
              preferredSize:const Size.fromHeight(0),
            child: Container(
              child: Center(child: BigText(product.name,size:Dimensions.font16+8,)),
              padding: EdgeInsets.only(top: Dimensions.height10-5,bottom: Dimensions.height10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular (Dimensions.radius20),
                      topRight: Radius.circular (Dimensions.radius20)
                  ),),
            ),

            ),
            pinned: true,
            backgroundColor: AppColors.yellowColor,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Image(
                image: NetworkImage(AppConstants.BASE_URL+AppConstants.UPLOAD_URL+product.img!),
                fit: BoxFit.cover,
                width: double.maxFinite,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(right: Dimensions.width20,left: Dimensions.width20),
               child: ExpandableText(text: product.description!,),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar:GetBuilder<PopularProductController>(
        builder: (popularProduct){
          return  Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: Dimensions.width20*2.5,
                  right: Dimensions.width20*2.5,
                  top: Dimensions.height10,
                  bottom: Dimensions.height10,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      GestureDetector(
                        child: AppIcon(
                            iconSize: Dimensions.iconSize24,
                            iconColor:Colors.white,
                            backgroundColor:AppColors.mainColor,
                            icon:Icons.remove),
                        onTap: (){
                          popularProduct.setQuantity(false);
                        },
                      ),
                      BigText('\$ ${product.price} X  ${popularProduct.inCartItems.toString()} ',color: AppColors.mainBlackColor,size: Dimensions.font16+8,),
                      GestureDetector(
                        onTap: (){
                          popularProduct.setQuantity(true);
                        },
                        child: AppIcon(
                            iconSize: Dimensions.iconSize24,
                            iconColor:Colors.white,
                            backgroundColor:AppColors.mainColor,
                            icon:Icons.add),
                      ) ,
                    ]

                ),
              ),
              Container(
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
                child: Row(
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
                      child: Icon( Icons.favorite,color: AppColors.mainColor,),
                    ),
                    GestureDetector(
                      onTap: (){
                       popularProduct.addItem(product);
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          top: Dimensions.height20/1.22,
                          bottom: Dimensions.height20,
                          left: Dimensions.width20,
                          right: Dimensions.width20,
                        ),
                        child: BigText("\$${product.price!}|Add to cart", color: Colors.white,),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular (Dimensions.radius20),
                            color: AppColors.mainColor
                        ), // BoxDecoration
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },

      ),
    );
  }
}
