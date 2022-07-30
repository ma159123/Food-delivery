
import 'package:food_delivery/models/products_model.dart';

class CartModel {
  int? id;
  String? name;
  int? quantity;
  bool?isExist;
  int? price;
  String? img;
  String? location;
  String?time;
  Products?product;

  CartModel(
      {this.id, this.name, this.price, this.quantity,this.isExist, this.img,this.time, this.location,this.product});

  CartModel.fromJson (Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    price = json['price'];
   img= json['img'];
    quantity = json['quantity'];
    isExist = json['isExist'];
    time = json['time'];
    product=Products.fromJson(json['product']);
  }

  Map<String, dynamic> toJson(){
    return {
      "id":id,
      "name":name,
      "price":price,
      "img":img,
      "quantity":quantity,
      "isExist":isExist,
      "time":time,
      "product":product!.toJason(),
  };

}


}