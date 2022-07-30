import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/data/controller/popular_product_controller.dart';
import 'package:food_delivery/data/controller/recommended_product_controller.dart';
import 'package:food_delivery/helper/route_helper.dart';
import 'package:food_delivery/models/products_model.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/constants/app_constants.dart';
import 'package:food_delivery/widgets/app_column.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/dimensions.dart';
import 'package:food_delivery/widgets/small_text.dart';
import 'package:get/get.dart';

import '../widgets/icon_and_text.dart';

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({Key? key}) : super(key: key);

  @override
  _FoodPageBodyState createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);
  double currentPageValue = 0.0;
  double scaleFactor = 0.8;
  double height = Dimensions.pageViewContainer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController.addListener(() {
      setState(() {
        currentPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        'dddddddddddddddd    ' + MediaQuery.of(context).size.height.toString());
    return Column(children: [
      //slide
      GetBuilder<PopularProductController>(
        builder: (popularProducts) {
        return popularProducts.isLoaded? Container(
            height: 320,
            child: PageView.builder(
              controller: pageController,
              itemBuilder: (context, index) => buildPageItem(index,popularProducts.popularProductList[index]),
              itemCount: popularProducts.popularProductList.length,
              scrollDirection: Axis.horizontal,
            ),
          ):Center(child: CircularProgressIndicator(color: AppColors.mainColor,));
        },
      ),
      //dots
      GetBuilder<PopularProductController>(
        builder: (popularProducts) {
          return DotsIndicator(
            dotsCount: popularProducts.popularProductList.isEmpty?1:popularProducts.popularProductList.length,
            position: currentPageValue,
            decorator: DotsDecorator(
              activeColor: AppColors.mainColor,
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          );
        },

      ),
      SizedBox(
        height: Dimensions.height30,
      ),

      //popular
      Container(
        margin: EdgeInsets.only(left: Dimensions.width30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            BigText("Recommended"),
            SizedBox(
              width: Dimensions.width10,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 3),
              child: BigText(".", color: Colors.black26),
            ), // Container
            SizedBox(
              width: Dimensions.width10,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 2),
              child: SmallText(
                "Food pairing",
              ),
            ) // Container
          ],
        ),
      ),
      GetBuilder<RecommendedProductController>(
        builder: (recommendedProduct) {
          return recommendedProduct.recommendedProductList.isEmpty?Center(child: CircularProgressIndicator(color: AppColors.mainColor,)):  ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: recommendedProduct.recommendedProductList.isEmpty?1:recommendedProduct.recommendedProductList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  Get.toNamed(AppRoute.getRecommendedFood(index,'home'));
                },
                child: Container(
                  margin: EdgeInsets.only(
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      bottom: Dimensions.height10),
                  child: Row(children: [
                    //image section
                    Container(
                      width: Dimensions.listViewImgSize,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                        color: Colors.white38,
                        image:  DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(AppConstants.BASE_URL+AppConstants.UPLOAD_URL+recommendedProduct.recommendedProductList[index].img!)),
                      ),
                    ),
                    //details section
                    Expanded(
                      child: Container(
                        height: Dimensions.listViewTextContSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(Dimensions.radius20),
                              bottomRight: Radius.circular(Dimensions.radius20)),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: Dimensions.width10, right: Dimensions.width10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BigText(recommendedProduct.recommendedProductList[index].name!),
                                SizedBox(height: Dimensions.height10,),
                                SmallText("With chinese characteristics",color: Colors.grey,),
                                SizedBox(height: Dimensions.height10,),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconAndTextWidget(
                                        icon: Icons.circle_sharp,
                                        iconColor: AppColors.iconColor1,
                                        text: 'Normal',
                                      ),
                                      IconAndTextWidget(
                                        icon: Icons.location_on,
                                        iconColor: AppColors.mainColor,
                                        text: '1.7km',
                                      ),
                                      IconAndTextWidget(
                                        icon: Icons.access_time_rounded,
                                        iconColor: AppColors.iconColor2,
                                        text: 'Normal',
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ]),
                ),
              );
            },
          );
        },

      ),

    ],
    );
  }

  Widget buildPageItem(int index,Products popularProducts) {
    Matrix4 matrix = Matrix4.identity();
    if (index == currentPageValue.floor()) {
      var currScale = 1 - (currentPageValue - index) * (1 - scaleFactor);
      var currTrans = height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == currentPageValue.floor() + 1) {
      var currScale =
          scaleFactor + (currentPageValue - index + 1) * (1 - scaleFactor);
      var currTrans = height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == currentPageValue.floor() - 1) {
      var currScale = 1 - (currentPageValue - index) * (1 - scaleFactor);
      var currTrans = height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, height * ((1 - scaleFactor) / 2), 0);
    }
    return Stack(children: [
      Transform(
        transform: matrix,
        child: GestureDetector(
          onTap: (){
            Get.toNamed(AppRoute.getPopularFood(index,'home'));
          },
          child: Container(
            height: Dimensions.pageViewContainer,
            margin: EdgeInsets.only(
                left: Dimensions.width10, right: Dimensions.width10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                image:  DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(AppConstants.BASE_URL+"/uploads/"+popularProducts.img!))),
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: Dimensions.pageViewTextContainer,
          margin: EdgeInsets.only(
              left: Dimensions.width40,
              right: Dimensions.width40,
              bottom: Dimensions.height30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius30),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color(0xffe8e8e8),
                blurRadius: 5.0,
                offset: Offset(0, 5),
              ),
              BoxShadow(
                color: Colors.white,
                // blurRadius: 5.0,
                offset: Offset(-5, 0),
              ),
              BoxShadow(
                color: Colors.white,
                // blurRadius: 5.0,
                offset: Offset(5, 0),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.only(
                right: Dimensions.width15,
                left: Dimensions.width15,
                top: Dimensions.pageViewTextContainerPadding),
            child: AppColumn(popularProducts.name!),
          ),
        ),
      ),
    ]);
  }
}
