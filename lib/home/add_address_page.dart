import 'package:flutter/material.dart';
import 'package:food_delivery/data/controller/address_controller.dart';
import 'package:food_delivery/data/controller/auth_controller.dart';
import 'package:food_delivery/data/controller/user_controller.dart';
import 'package:food_delivery/home/pick_address_map.dart';
import 'package:food_delivery/models/address_model.dart';
import 'package:food_delivery/widgets/app_text_field.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/dimensions.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../base/custom_app_bar.dart';
import '../helper/route_helper.dart';
import '../utils/colors.dart';

class AddAddressPage extends StatefulWidget {
  bool fromPickAddressPage;
   AddAddressPage({Key? key,required this.fromPickAddressPage}) : super(key: key);

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final TextEditingController _contactPersonName = TextEditingController();
  final TextEditingController _contactPersonNumber = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  late bool _isLogged;
 late CameraPosition _cameraPosition ;
  late LatLng _initialPosition ; //دول بيتعرفوا من جديد فالحل اني احفظ الداتا  فالaddressList   او اني استقبلهم من صفحة ال pickAddress

  @override
  void initState() {
    super.initState();
    if (!widget.fromPickAddressPage) {
      _isLogged = Get.find<AuthController>().isUserLogin();
      if (_isLogged && Get
          .find<UserController>()
          .userModel == null) {
        Get.find<UserController>().getUserData();
      }
      if (Get
          .find<AddressController>()
          .addressList
          .isNotEmpty) {
        print(
            "address list not empty&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
        if (Get.find<AddressController>().getUserAddressFromLocalStorage() ==
            "") {
          print(
              "Saviiiiiiing user adresss&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
          Get.find<AddressController>()
              .saveUserAddress(Get
              .find<AddressController>()
              .addressList
              .last);
        }
        AddressModel addressModel =
        Get.find<AddressController>().getUserAddress()!;
        _cameraPosition = CameraPosition(
          target: LatLng(
            double.parse(addressModel.latitude!),
            double.parse(addressModel.longitude!),
          ),
        );
        _initialPosition = LatLng(
          double.parse(addressModel.latitude!),
          double.parse(addressModel.longitude!),
        );
      } else {
         _cameraPosition = const CameraPosition(target: LatLng(30.06, 31.25), zoom: 17);
          _initialPosition = const LatLng(30.06, 31.25);
        print(
            "address list empty&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
      }
    }else{
      _cameraPosition = CameraPosition(
        target:LatLng(
          Get.find<AddressController>().pickPosition.latitude,
            Get.find<AddressController>().pickPosition.longitude),
      );
      _initialPosition = LatLng(
          Get.find<AddressController>().pickPosition.latitude,
          Get.find<AddressController>().pickPosition.longitude);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Address Page',backButtonExist: true,onBackPressed: ()=>Get.toNamed(AppRoute.getInitialPage())),
      body: GetBuilder<UserController>(
        builder: (userController) {
          if (userController.userModel != null &&
              _contactPersonName.text.isEmpty) {
            _contactPersonName.text = userController.userModel!.name!;
            _contactPersonNumber.text = userController.userModel!.phone!;
            // if (Get.find<AddressController>().addressList.isNotEmpty&&!widget.fromPickAddressPage) {
            //   _addressController.text =
            //       Get.find<AddressController>().getUserAddress().address;
            // } else {
            //   print('eeeeeeeeeeempty');
            // }
          }
          return GetBuilder<AddressController>(
            builder: (addressController) {
              _addressController.text =(!widget.fromPickAddressPage?_isLogged?Get.find<AddressController>().addressRepo.getUserAddress()!=''?addressController.getUserAddress()!.address:'':
                      addressController.placeMark.name ?? ''
                         : addressController.pickPlaceMark.name ?? '')!;
              //  print("address########################## in page..." + _addressController.text);
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //map
                    Container(
                      height: Dimensions.height70 * 2,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: Dimensions.width10 / 2,
                          right: Dimensions.width10 / 2,
                          top: Dimensions.height10 / 2),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius15 / 3),
                        border: Border.all(
                            width: Dimensions.width10 / 5,
                            color: Theme.of(context).primaryColor),
                      ),
                      child: Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: _initialPosition, zoom: 17),
                            onTap: (latlng) {
                              Get.toNamed(
                                AppRoute.getPickAddressPage(),
                                arguments: PickAddressMap(
                                    fromSignupPage: false,
                                    fromAddressPage: true,
                                    googleMapController:
                                        addressController.googleMapController),
                              );
                            },
                            zoomControlsEnabled: false,
                            compassEnabled: false,
                            indoorViewEnabled: true,
                            mapToolbarEnabled: false,
                            myLocationEnabled: true,
                            onCameraIdle: () {
                              addressController.updatePosition(
                                  _cameraPosition, true);
                            },
                            onCameraMove: ((position) =>
                                _cameraPosition = position),
                            onMapCreated: (GoogleMapController controller) {
                              addressController.setMapController(controller);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    //addressType
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.width20),
                      child: SizedBox(
                        height: Dimensions.height10 * 7,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: addressController.addressTypeList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                addressController.changeAddressType(index);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width20,
                                    vertical: Dimensions.height10),
                                margin: EdgeInsets.only(
                                    top: Dimensions.height10,
                                    right: Dimensions.width10,
                                    bottom: Dimensions.height10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius20 / 4),
                                  color: Theme.of(context).cardColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[200]!,
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  index == 0
                                      ? Icons.home
                                      : index == 1
                                          ? Icons.work
                                          : Icons.location_on,
                                  color: addressController.addressTypeIndex ==
                                          index
                                      ? AppColors.mainColor
                                      : Theme.of(context).disabledColor,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.width20),
                      child: BigText('Delivery Address'),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    AppTextField(
                        textEditingController: _addressController,
                        hintText: 'Your address',
                        icon: Icons.map),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.width20),
                      child: BigText('Delivery Address'),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    AppTextField(
                        textEditingController: _contactPersonName,
                        hintText: 'Your name',
                        icon: Icons.person),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.width20),
                      child: BigText('Delivery Address'),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    AppTextField(
                        textEditingController: _contactPersonNumber,
                        hintText: 'Your number',
                        icon: Icons.phone),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: GetBuilder<AddressController>(
        builder: (addressController) {
          return Container(
            height: Dimensions.bottomHeightBar,
            padding: EdgeInsets.only(
                left: Dimensions.width20,
                right: Dimensions.width20,
                top: Dimensions.height30,
                bottom: Dimensions.height30),
            decoration: BoxDecoration(
                color: AppColors.buttonBackgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius20 * 2),
                    topRight: Radius.circular(Dimensions.radius20 * 2))),
            child: GestureDetector(
              onTap: () {
                AddressModel addressModel = AddressModel(
                  addressType: addressController
                      .addressTypeList[addressController.addressTypeIndex],
                  longitude: addressController.position.longitude.toString(),
                  latitude: addressController.position.latitude.toString(),
                  address: _addressController.text,
                  contactPersonName: _contactPersonName.text,
                  contactPersonNumber: _contactPersonNumber.text,
                );
                addressController.addAddress(addressModel).then((value) {
                  if (value.isSuccess) {
                    Get.toNamed(AppRoute.getInitialPage());
                    Get.snackbar('Address', 'Added successfully',
                        backgroundColor: AppColors.mainColor);
                  } else {
                    Get.snackbar('Address', 'Addition failed',
                        backgroundColor: Colors.redAccent);
                  }
                });
                // popularProduct.addItem(product);
              },
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(
                    top: Dimensions.height20 / 1.22,
                    bottom: Dimensions.height20,
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                  ),
                  child: BigText(
                    "Save address",
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      color: AppColors.mainColor), // BoxDecoration
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
