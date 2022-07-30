import 'package:flutter/material.dart';
import 'package:food_delivery/data/controller/cart_controller.dart';
import 'package:food_delivery/models/cart_model.dart';
import 'package:food_delivery/models/products_model.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../repo/popular_data_repo.dart';

class PopularProductController extends GetxController {
  PopularProductRepo popularDataRepo;

  PopularProductController({required this.popularDataRepo});

  List<dynamic> _popularProductList = [];

  List<dynamic> get popularProductList => _popularProductList;

  int _quantity = 0;
  bool isExist=false;

  int get quantity => _quantity;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  int _inCartItems = 0;

  int get inCartItems => _inCartItems + _quantity;
  late CartController _cart;

  Future<void> getPopularProductList() async {
    Response response = await popularDataRepo.getPopularProductRepo();
    if (response.statusCode == 200) {
      print("got data");
      _popularProductList = [];
      _popularProductList.addAll(ProductsModel
          .fromJson(response.body)
          .products);
      _isLoaded = true;
      update();
    } else {
      // print("got data");
    }
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = checkQuantity(_quantity + 1);
      print("increment " + _quantity.toString());
    } else {
      _quantity = checkQuantity(_quantity - 1);
      print("decrement " + _quantity.toString());
    }
    update();
  }

  void initQuantity(Products product,CartController cart) {
    _quantity = 0;
    _inCartItems = 0;
    _cart = cart;
    isExist=_cart.isProductExist(product);
    if(isExist){
     _inCartItems= _cart.getQuantity(product);
      print('exist or not '+isExist.toString());
    }
    print('quantity is'+_inCartItems.toString());
  }

  int checkQuantity(int quantity) {
    if ((_inCartItems+quantity) < 0) {
      Get.snackbar("Item count", "You can't reduce more !",
        backgroundColor: AppColors.mainColor,
        colorText: Colors.white,
      );
      if(_inCartItems>0){
        _quantity = -_inCartItems;
        print(_quantity);
        return _quantity;
      }
      return 0;
    } else if ((_inCartItems+quantity) > 20) {
      Get.snackbar("Item count", "You can't add more !",
        backgroundColor: AppColors.mainColor,
        colorText: Colors.white,
      );
      return 20;
    } else {
      return quantity;
    }
  }

  void addItem(Products product) {
      _cart.addItem(product, quantity);
      _quantity=0;
     _inCartItems=_cart.getQuantity(product);
      _cart.items.forEach((key, value) {
        print('product id '+value.id.toString()+" product quantity "+value.quantity.toString());
      });
   update();
  }

  int get totalQuantity{
   return _cart.totalQuantity;
  }

  List<CartModel>get getCartItems{
    return _cart.getCartItems;
  }
}
