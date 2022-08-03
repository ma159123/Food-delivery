import 'package:food_delivery/data/repo/order_repo.dart';
import 'package:food_delivery/models/order_model.dart';
import 'package:food_delivery/models/place_order_model.dart';
import 'package:get/get.dart';

class OrderController extends GetxController implements GetxService{
   OrderRepo orderRepo;
   OrderController({required this.orderRepo});

   bool _isLoading=false;
   bool get isLoading=>_isLoading;
  late List<OrderModel> _currentOrderList;
  late List<OrderModel> _historyOrderList;

   List<OrderModel>?_allOrders;
  List<OrderModel>? get allOrders=>_allOrders;
  List<OrderModel> get currentOrderList=>_currentOrderList;
  List<OrderModel> get historyOrderList=>_historyOrderList;
  int _paymentIndex=0;
  int get paymentIndex=>_paymentIndex;
  String _orderType='delivery';
  String get orderType=>_orderType;

  String _foodNote='';
  String get foodNote=>_foodNote;
  Future<void> placeOrder(PlaceOrderModel placeOrder,Function callBack,OrderModel orderModel)async{
    _isLoading=true;
     Response response =await orderRepo.placeOrder(placeOrder);
     if(response.statusCode==200){
       _isLoading=false;
       String message=response.body['message'];
       String orderId=response.body['order_id'].toString();
       callBack(true,message,orderId);
     }else{
       print('status code is...:'+response.statusCode.toString());
        callBack(false,response.statusText!,'-1');
     }
    _isLoading=false;
     update();
   }
   void addToOrderList(OrderModel orderModel){
    _allOrders ??= [];
    _allOrders!.add(orderModel);
    update();
   }

Future<void> getOrderList()async{
_isLoading=true;
  Response response= await  orderRepo.getOrderList();
  if(response.statusCode==200){
    _historyOrderList=[];
    _currentOrderList=[];
  response.body.forEach((order){
    OrderModel orderModel=OrderModel.fromJson(order);
    if(orderModel.orderStatus=='pending'||orderModel.orderStatus=='accepted'||orderModel.orderStatus=='processing'||orderModel.orderStatus=='handover'||orderModel.orderStatus=='picked_up'){
      _currentOrderList.add(orderModel);
    }else{
      _historyOrderList.add(orderModel);
    }

  });
  //print('cooooooooooode is 200');
  }else{
    _historyOrderList=[];
    _currentOrderList=[];
    //print('cooooooooooode is '+response.statusCode.toString());
  }
  _isLoading=false;
  //print('current orders: '+_currentOrderList.length.toString());
//print('history orders: '+_historyOrderList.length.toString());

  update();
}

void setPaymentOption(int index){
  _paymentIndex=index;
    update();
}
void setOrderType(String value){
    _orderType=value;
    update();
}
void setFoodNote(String note){
    _foodNote=note;
}
}