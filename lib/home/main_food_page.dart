import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:get/get.dart';

import '../data/controller/popular_product_controller.dart';
import '../data/controller/recommended_product_controller.dart';
import '../widgets/dimensions.dart';
import '../widgets/small_text.dart';
import 'food_page_body.dart';

class MainFoodPage extends StatefulWidget {
  const MainFoodPage({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<MainFoodPage> {
  Future<void> _loadResources()async{
    await Get.find<PopularProductController>().getPopularProductList();
    await Get.find<RecommendedProductController>().getRecommendedProductList();
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(child:  Column(
      children: [
        Container(
          child: Container(
            margin:  EdgeInsets.only(top: Dimensions.height70,bottom: Dimensions.height15),
            padding:  EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    BigText('fooodfgdo'),
                    Row(
                      children: [
                        SmallText('juuuday'),
                        IconButton(
                          icon: const Icon(Icons.arrow_drop_down),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: Dimensions.width45,
                  height: Dimensions.height45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    color: AppColors.mainColor,
                  ),
                  child:  Icon(Icons.search,color: Colors.white,size: Dimensions.iconSize24,),
                ),
              ],
            ),
          ),
        ),
        const Expanded(child: SingleChildScrollView(child: FoodPageBody())),
      ],
    ), onRefresh:_loadResources );
  }

}
