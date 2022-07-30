import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:food_delivery/data/Api/api_checker.dart';
import 'package:food_delivery/data/controller/user_controller.dart';
import 'package:food_delivery/data/repo/address_repo.dart';
import 'package:food_delivery/models/address_model.dart';
import 'package:food_delivery/models/response_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/src/places.dart';

import '../../models/user_model.dart';

class AddressController extends GetxController implements GetxService {
  AddressRepo addressRepo;

  AddressController({required this.addressRepo});

  bool _loading = false;
  late Position _position;
  late Position _pickPosition;
  Placemark _placeMark = Placemark();
  Placemark _pickPlaceMark = Placemark();

  Placemark get placeMark => _placeMark;

  Placemark get pickPlaceMark => _pickPlaceMark;
  List<AddressModel> _addressList = [];

  List<AddressModel> get addressList => _addressList;
  late List<AddressModel> _allAddressList;
  bool _updateAddressData = true;

  bool get loading => _loading;

  Position get position => _position;

  Position get pickPosition => _pickPosition;
  final List<String> _addressTypeList = ["home", "office", "others"];
  int _addressTypeIndex = 0;
  bool _changeAddress = true;

  List<String> get addressTypeList => _addressTypeList;

  int get addressTypeIndex => _addressTypeIndex;

  late GoogleMapController _googleMapController;

  GoogleMapController get googleMapController => _googleMapController;

  bool _isLoading = false; //for service zone
  bool get isLoading => _isLoading;
  bool _inZone = true;

  bool get inZone => _inZone;
  bool _buttonDisable = true; //show & hide the pickButton
  bool get buttonDisable => _buttonDisable;

  List<Prediction> _predictionList = [];

  void setMapController(GoogleMapController googleMapController) {
    _googleMapController = googleMapController;
  }

  Future<void> updatePosition(CameraPosition position, bool fromAddress) async {
    if (_updateAddressData) {
      _loading = true;
      update();
      try {
        if (fromAddress) {
          print("putttttttting position");
          _position = Position(
            latitude: position.target.latitude,
            longitude: position.target.longitude,
            timestamp: DateTime.now(),
            heading: 1,
            accuracy: 1,
            altitude: 1,
            speedAccuracy: 1,
            speed: 1,
          );
        } else {
          print('putting pick position');
          _pickPosition = Position(
            latitude: position.target.latitude,
            longitude: position.target.longitude,
            timestamp: DateTime.now(),
            heading: 1,
            accuracy: 1,
            altitude: 1,
            speedAccuracy: 1,
            speed: 1,
          );
        }
        ResponseModel _responseModel = await getZone(
            position.target.latitude.toString(),
            position.target.longitude.toString(),
            true);
        _buttonDisable = !_responseModel.isSuccess;

        if (_changeAddress) {
          String _address = await getAddressFromGeocode(
            LatLng(
              position.target.latitude,
              position.target.longitude,
            ),
          );
          fromAddress
              ? _placeMark = Placemark(name: _address)
              : _pickPlaceMark = Placemark(name: _address);
        }else{
          _changeAddress=true;
        }
      } catch (e) {
        print(e.toString());
      }
      _loading = false;
      update();
    } else {
      _updateAddressData = true;
    }
  }

  Future<String> getAddressFromGeocode(LatLng latlng) async {
    String _address = 'Unknown Location Found';
    Response response = await addressRepo.getAddressFromGeocode(latlng);
    if (response.body['status'] == 'OK') {
      _address = response.body['results'][0]['formatted_address'].toString();
      print('adress' + _address);
    } else {
      print('Error getting the google api');
    }
    update();
    return _address;
  }

  late Map<String, dynamic> _getAddress;

  Map<String, dynamic> get getAddress => _getAddress;

  AddressModel? getUserAddress() {
     AddressModel? _addressModel;

   if(Get.find<AddressController>().addressRepo.getUserAddress()!='') {
     _getAddress = jsonDecode(addressRepo.getUserAddress());
   }


    try {
      _addressModel = AddressModel.fromJson(_getAddress);
      String userAddress = jsonEncode(_addressModel.toJson());
      _addressList.add(AddressModel.fromJson(jsonDecode(userAddress)));
    } catch (e) {
      print(e.toString());
    }
    return _addressModel;
  }

  void changeAddressType(int index) {
    _addressTypeIndex = index;
    update();
  }

  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    _loading = true;
    update();
    Response response = await addressRepo.addAddress(addressModel);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      await getAddressList();
      String message = response.body['message'];
      responseModel = ResponseModel(true, message);
      await saveUserAddress(addressModel);
    } else {
      print("couldn't save the address");
      responseModel = ResponseModel(false, response.statusText!);
    }
    update();
    return responseModel;
  }

  Future<void> getAddressList() async {
    Response response = await addressRepo.getAddressList();
    if (response.statusCode == 200) {
      print("geeeeeeeeeeeeeeeeeeeee####################t address success");
      _addressList = [];
      _allAddressList = [];
      response.body.forEach((address) {
        _addressList.add(AddressModel.fromJson(address));
        _allAddressList.add(AddressModel.fromJson(address));
      });
    } else {
      print("geeeeeeeeeeeeeeeeeeeee####################t address failed");
      _addressList = [];
      _allAddressList = [];
    }
    update();
  }

  Future<bool> saveUserAddress(AddressModel addressModel) async {
    String userAddress = jsonEncode(addressModel.toJson());
    _addressList.add(AddressModel.fromJson(jsonDecode(userAddress)));
    // print('saaaaaaaaaaaaaving addreeeeeeeeess');
    // for(int i=0;i<_addressList.length;i++){
    //   print(_addressList[i].address);
    // }
    return await addressRepo.saveUserAddress(userAddress);

  }

  void clearAddressList() {
    _addressList = [];
    _allAddressList = [];
    update();
  }

  String getUserAddressFromLocalStorage() {
    return addressRepo.getUserAddress();
  }

  Future<void> setAddAddressData() async {
    print('set Add Address Data fun callllllllllllllled');
    _position = _pickPosition;
    _placeMark = _pickPlaceMark;
    _updateAddressData = false;
    update();
  }

  Future<ResponseModel> getZone(String lat, String lng, bool markerLoad) async {
    late ResponseModel responseModel;
    if (markerLoad) {
      _loading = true;
    } else {
      _isLoading = true;
    }
    update();
    Response response = await addressRepo.getZone(lat, lng);
    if (response.statusCode == 200) {
      _inZone = true;
      responseModel = ResponseModel(true, response.body['zone_id'].toString());
    } else {
      _inZone = false;
      responseModel = ResponseModel(true, response.statusText!);
    }
    if (markerLoad) {
      _loading = false;
    } else {
      _isLoading = false;
    }
    print(response.statusCode);
    update();
    return responseModel;
  }

  Future<List<Prediction>> searchLocation(
      BuildContext context, String text) async {
    if (text.isNotEmpty) {
      Response response = await addressRepo.searchLocation(text);
      if (response.statusCode == 200 && response.body['status'] == 'OK') {
        _predictionList = [];
        response.body['predictions'].forEach((prediction) {
          _predictionList.add(Prediction.fromJson(prediction));
        });
      } else {
        ApiChecker.checkApi(response);
      }
    }
    return _predictionList;
  }

  setLocation(
      String placeId, String address, GoogleMapController mapController) async {
    _loading = true;
    update();
    PlacesDetailsResponse details;
    Response response = await addressRepo.setLocation(placeId);
    details = PlacesDetailsResponse.fromJson(response.body);
    _pickPosition = Position(
      latitude: details.result.geometry!.location.lat,
      longitude: details.result.geometry!.location.lng,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1,
    );
    _pickPlaceMark = Placemark(name: address);
    _changeAddress = false;
    _loading = false;
    if (mapController != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(
            details.result.geometry!.location.lat,
            details.result.geometry!.location.lng,
          ),
          zoom: 17,
        )),
      );
    }
    update();
  }
}
