import 'package:flutter/material.dart';
import 'package:food_delivery/data/Api/api_client.dart';
import 'package:food_delivery/models/address_model.dart';
import 'package:food_delivery/utils/constants/app_constants.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressRepo {
  ApiClient apiClient;
  SharedPreferences sharedPreferences;
  AddressRepo({required this.apiClient,required this.sharedPreferences});

  Future<Response> getAddressFromGeocode(LatLng latLng)async{
    return await apiClient.getData('${AppConstants.GEOCODE_URL}''?lat=${latLng.longitude}&lng=${latLng.longitude}');
  }

  String getUserAddress(){
    return sharedPreferences.getString(AppConstants.USER_ADDRESS)??'';
  }

  Future<Response> addAddress(AddressModel addressModel){
    return apiClient.postData(AppConstants.ADD_USER_ADDRESS, addressModel.toJson());
  }

  Future<Response>getAddressList()async{
   return await apiClient.getData(AppConstants.ADDRESS_LIST_URI);
  }

 Future<bool> saveUserAddress(String address)async{
    apiClient.updateHeaders(sharedPreferences.getString(AppConstants.IOKEN)!);
  return await  sharedPreferences.setString(AppConstants.USER_ADDRESS, address );
  }

  Future<Response> getZone(String lat,String lng)async{
    return await apiClient.getData('${AppConstants.ZONE_URI}?lat=$lat&lng=$lng');
  }

Future<Response> searchLocation(String text)async{
    return await apiClient.getData('${AppConstants.SEARCH_LOCATION_URL}?search_text=$text');
}

Future<Response> setLocation(String placeId)async{
    return await apiClient.getData('${AppConstants.PLACE_DETAILS_URL}?placeid=$placeId');
}

}