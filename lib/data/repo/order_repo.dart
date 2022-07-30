import 'package:food_delivery/data/Api/api_client.dart';
import 'package:food_delivery/models/place_order_model.dart';
import 'package:food_delivery/utils/constants/app_constants.dart';
import 'package:get/get.dart';

class OrderRepo{
  ApiClient apiClient;
  OrderRepo({required this.apiClient});

 Future<Response> placeOrder(PlaceOrderModel placeModel)async{
    return await apiClient.postData(AppConstants.PLACE_ORDER_URI,placeModel.toJson());
  }

  Future<Response> getOrderList()async{
    return await apiClient.getData(AppConstants.ORDER_LIST_URI);
  }
}