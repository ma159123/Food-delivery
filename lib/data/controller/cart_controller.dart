import 'package:flutter/material.dart';
import 'package:food_delivery/data/repo/cart_repo.dart';
import 'package:food_delivery/models/cart_model.dart';
import 'package:food_delivery/models/products_model.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';

class CartController extends GetxController {
  CartRepo cartRepo;

  CartController({required this.cartRepo});

  late Map<int, CartModel>_items = {};

  Map<int, CartModel> get items => _items;

  List<CartModel> storageItems=[];

  void addItem(Products product, int quantity) {
    int totalQuantity = 0;
    if (_items.containsKey(product.id!)) {
      _items.update(product.id!, (value) {
        totalQuantity = value.quantity! + quantity;
        return CartModel(
          id: product.id,
          name: value.name,
          price: value.price,
          img: value.img,
          quantity: value.quantity! + quantity,
          isExist: true,
          time: DateTime.now().toString(),
          product: product,
        );
      });
      if (totalQuantity == 0) {
        _items.remove(product.id);
      }
    } else {
      if (quantity > 0) {
        _items.putIfAbsent(product.id!, () {
          print('item is added' + product.id.toString() + ' ' +
              quantity.toString());
          return CartModel(
            id: product.id,
            name: product.name,
            price: product.price,
            img: product.img,
            quantity: quantity,
            isExist: true,
            time: DateTime.now().toString(),
            product: product,
          );
        });
      } else {
        Get.snackbar("Item count", "You should more than 0 ",
          backgroundColor: AppColors.mainColor,
          colorText: Colors.white,
        );
      }
    }

   cartRepo.addToCart(getCartItems);
    update();
  }

  bool isProductExist(Products product) {
    if (_items.containsKey(product.id)) {
      return true;
    } else {
      return false;
    }
  }

  int getQuantity(Products product) {
    int quantity = 0;
    if (_items.containsKey(product.id)) {
      _items.forEach((key, value) {
        if (key == product.id) {
          quantity = value.quantity!;
        }
      });
    }
    return quantity;
  }

  int get totalQuantity {
    int totalQuantity = 0;
    _items.forEach((key, value) {
      totalQuantity += value.quantity!;
    });
    return totalQuantity;
  }

  List<CartModel> get getCartItems {
    return _items.entries.map((e) {
      return e.value;
    }).toList();
  }

  //total price
  int get totalAmount {
    var total = 0;
    items.forEach((key, value) {
      total += value.quantity! * value.price!;
    });
    return total;
  }

  List<CartModel> getStorageItems(){
    setStorageItems=cartRepo.getCart();
    return storageItems;
  }

  set setStorageItems(List<CartModel> items){
    storageItems=items;

    print('cart items number is: '+ storageItems.length.toString());
    for(int i=0;i<storageItems.length;i++){
      _items.putIfAbsent(storageItems[i].product!.id!, () => storageItems[i]);
    }
  }

  void addToHistoryList(){
    cartRepo.addToHistoryList();
    clear();
  }
  void clear(){
    _items={};
    update();
  }

  List<CartModel> getCartHistoryList(){
    return cartRepo.getHistoryCart();
  }

  set addOrderItems(Map<int,CartModel> orderItems){
    _items={};
    _items=orderItems;
  }
  void addToCartList(){
    cartRepo.addToCart(getCartItems);
    update();
  }

  void clearCartHistory(){
    cartRepo.clearCartHistory();
  }

  void removeCartSharedPreference(){
    cartRepo.removeCartSharedPreference();
  }
}