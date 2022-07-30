import 'dart:convert';

import 'package:food_delivery/utils/constants/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/cart_model.dart';

class CartRepo extends GetxService{
 final  SharedPreferences sharedPreferences;
   CartRepo({required this.sharedPreferences});

   List<String>cart=[];
   List<String> historyList=[];
   var time=DateTime.now().toString();
   void addToCart(List<CartModel>cartList){
    // sharedPreferences.remove(AppConstants.HISTORY_LIST_KEY);
    // sharedPreferences.remove(AppConstants.CART_LIST_KEY);
    // return;
     cart=[];
     for (var element in cartList) {
       element.time=time;
      return cart.add(jsonEncode(element));
     }

     sharedPreferences.setStringList(AppConstants.CART_LIST_KEY, cart);
   //  print('####################################');
    // print(sharedPreferences.getStringList(AppConstants.CART_LIST_KEY));
     getCart();
   }

   List<CartModel> getCart(){
     List<String> carts=[];
     if(sharedPreferences.containsKey(AppConstants.CART_LIST_KEY)){
       carts=sharedPreferences.getStringList(AppConstants.CART_LIST_KEY)!;
       print('inside getcart'+carts.toString());
     }
     List<CartModel> cartList=[];
     carts.forEach((element) {
       cartList.add(CartModel.fromJson(jsonDecode(element)));
     });

     return cartList;
   }

   void addToHistoryList(){
     if(sharedPreferences.containsKey(AppConstants.HISTORY_LIST_KEY)){
       historyList=sharedPreferences.getStringList(AppConstants.HISTORY_LIST_KEY)!;
     }
     for(int i=0; i<cart.length;i++){
       historyList.add(cart[i]);
     }
    cart=[];
     sharedPreferences.setStringList(AppConstants.HISTORY_LIST_KEY, historyList);

   }
   void removeCart(){
     cart=[];
     sharedPreferences.remove(AppConstants.CART_LIST_KEY);
   }

   void clearCartHistory(){
     removeCart();
     historyList=[];
     sharedPreferences.remove(AppConstants.HISTORY_LIST_KEY);
   }


   List<CartModel> getHistoryCart(){
     historyList=[];
     if(sharedPreferences.containsKey(AppConstants.HISTORY_LIST_KEY)){
       historyList=sharedPreferences.getStringList(AppConstants.HISTORY_LIST_KEY)!;

     }
     List<CartModel> history=[];
     historyList.forEach((element)=>history.add(CartModel.fromJson(jsonDecode(element))));
   return history;
   }
   
   void removeCartSharedPreference(){
     sharedPreferences.remove(AppConstants.CART_LIST_KEY);
     sharedPreferences.remove(AppConstants.HISTORY_LIST_KEY);
   }
}