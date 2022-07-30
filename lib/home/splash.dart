import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_delivery/widgets/dimensions.dart';
import 'package:get/get.dart';

import '../data/controller/popular_product_controller.dart';
import '../data/controller/recommended_product_controller.dart';
import '../helper/route_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  late Animation<double>animation;
  late AnimationController animationController;

 Future<void> _loadResources()async{
   await Get.find<PopularProductController>().getPopularProductList();
   await Get.find<RecommendedProductController>().getRecommendedProductList();
  }

  @override
  void initState() {
    super.initState();
    _loadResources();
    animationController=AnimationController(vsync: this,duration: const Duration(seconds: 2),)..forward();
    animation=CurvedAnimation(parent: animationController, curve: Curves.linear);

    Timer(const Duration(seconds: 3), () =>Get.offNamed(AppRoute.getInitialPage()) );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment:  MainAxisAlignment.center,
          children: [
        ScaleTransition(scale: animation,
        child: Center (child: Image.asset("assets/image/logo part 1.png",width: Dimensions.width40*6.25),)),
        Center (child: Image.asset("assets/image/logo part 2.png",width: Dimensions.splashWidth*3,),),
          ],
        ),
    );
  }
  @override
  dispose() {
    animationController.dispose(); // you need this
    super.dispose();
  }
}
