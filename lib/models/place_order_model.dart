import 'package:food_delivery/models/cart_model.dart';

class PlaceOrderModel{
   List<CartModel>? _cart;
  late double _orderAmount;
  late String _orderNote;
  late String _scheduleAt;
  late double _distance;
  late String _address;
  late String _latitude;
  late String  _longitude;
  late String _contactPersonName;
  late String _contactPersonNumber;
late String _orderType;
late String _paymentMethod;

  PlaceOrderModel({
    required List<CartModel> cart,
    required double orderAmount,
    required String orderNote,
    required double distance,
    required String address,
    required String latitude,
    required String longitude,
    required String contactPersonName,
    required String contactPersonNumber,
    required String scheduledAt,
    required String orderType,
    required String paymentMethod,
}) {
    this._cart=cart;
    this._address=address;
    this._contactPersonNumber=contactPersonNumber;
    this._contactPersonName=contactPersonName;
    this._longitude=longitude;
    this._latitude=latitude;
    this._distance=distance;
    this._orderAmount=orderAmount;
    this._orderNote=orderNote;
    this._scheduleAt=scheduledAt;
    this._orderType=orderType;
    this._paymentMethod=paymentMethod;
  }

  PlaceOrderModel.fromJson(Map<String,dynamic>json){
    if(json['cart']!=null){
      _cart=[];
      json['cart'].forEach((v){
        _cart!.add(CartModel.fromJson(v));
      }
      );
    }

   _orderAmount= json['order_amount'];
  _orderNote=  json['order_note'];
   _distance= json['distance'];
   _address= json['address'];
   _latitude= json['latitude'];
   _longitude= json['longitude'];
    _contactPersonName=json['contact_person_name'];
    _contactPersonNumber=json['contact_person_number'];
     //  _orderType=json['order_type'];
     //_paymentMethod=json['payment_method'];

  }

  Map<String,dynamic>toJson(){
    Map<String,dynamic>data=<String,dynamic>{};
    if(this._cart!=null){
      data['cart']=_cart!.map((e) => e.toJson()).toList();
    }
    data['order_amount']=_orderAmount;
    data['order_note']=_orderNote;
    data['distance']=_distance;
    data['address']=_address;
    data['latitude']=_latitude;
    data['longitude']=_longitude;
    data['contact_person_name']=_contactPersonName;
    data['contact_person_number']=_contactPersonNumber;
    data['order_type']=_orderType;
    data['payment_method']=_paymentMethod;
    return data;
  }
}