import 'package:flutter/material.dart';
import 'package:food_delivery/data/controller/address_controller.dart';
import 'package:food_delivery/helper/route_helper.dart';
import 'package:food_delivery/home/add_address_page.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/widgets/custom_button.dart';
import 'package:food_delivery/widgets/dimensions.dart';
import 'package:food_delivery/widgets/search_location_dialogue.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickAddressMap extends StatefulWidget {
  bool fromSignupPage;
  bool fromAddressPage;
 final GoogleMapController googleMapController;

  PickAddressMap(
      {Key? key,
      required this.fromSignupPage,
      required this.fromAddressPage,
      required this.googleMapController})
      : super(key: key);

  @override
  State<PickAddressMap> createState() => _PickAddressMapState();
}

class _PickAddressMapState extends State<PickAddressMap> {
  late LatLng _initialPosition;

  late GoogleMapController _googleMapController;

  late CameraPosition _cameraPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.find<AddressController>().addressList.isEmpty) {
      _initialPosition = const LatLng(30.06, 31.25);
      _cameraPosition = CameraPosition(target: _initialPosition, zoom: 17);
    } else if (Get.find<AddressController>().addressList.isNotEmpty) {
      _initialPosition = LatLng(
          double.parse(Get.find<AddressController>().getAddress['latitude']),
         double.parse( Get.find<AddressController>().getAddress['longitude']),
      );
      _cameraPosition = CameraPosition(target: _initialPosition, zoom: 17);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressController>(
      builder: (addressController) {
        return Scaffold(
          body: SafeArea(
            child: SizedBox(
              width: double.maxFinite,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 17,
                    ),
                    zoomControlsEnabled: false,
                    onCameraMove: (CameraPosition cameraPosition) {
                      _cameraPosition = cameraPosition;
                    },
                    onCameraIdle: () {
                      Get.find<AddressController>()
                          .updatePosition(_cameraPosition, false);
                    },
                    onMapCreated: (GoogleMapController mapController){
                      _googleMapController=mapController;

                    },
                  ),
                  Center(
                    child: addressController.loading
                        ? const CircularProgressIndicator()
                        : Image.asset(
                            'assets/image/pick_marker.png',
                            width: Dimensions.width45,
                            height: Dimensions.height45,
                          ),
                  ),
                  Positioned(
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    top: Dimensions.height45,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimensions.width15),
                      height: Dimensions.height45,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius15),
                        color: AppColors.mainColor,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 25,
                            color: AppColors.yellowColor,
                          ),
                          Expanded(
                            child: Text(
                              addressController.pickPlaceMark.name ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: Dimensions.font16,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: Dimensions.width20,),
                          InkWell(
                            onTap: ()=>Get.dialog(LocationDialogue(mapController: _googleMapController)),
                            child: Icon(
                              Icons.search,
                              size: 25,
                              color: AppColors.yellowColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: Dimensions.screenHeight/1.5,
                    left: Dimensions.width30,
                    child: Center(
                      child:addressController.isLoading?const Center(child: CircularProgressIndicator(),): CustomButton(
                        buttonText:addressController.inZone? widget.fromAddressPage?'Pick Address':'Pick location':'Service not available',
                        onPressed:(addressController.buttonDisable|| addressController.loading) ?null : () {
                                 if (addressController.pickPosition.latitude !=0 &&
                                    addressController.pickPlaceMark.name != null) {
                                  if (widget.fromAddressPage) {
                                    if (widget.googleMapController != null) {
                                      print('yo33333333333333u can clicked on');
                                      widget.googleMapController.moveCamera(
                                        CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                            target: LatLng(
                                                addressController.pickPosition.latitude,
                                                addressController.pickPosition.longitude),
                                          ),
                                        ),
                                      );
                                      addressController.setAddAddressData();

                                    }
                                    Get.toNamed(AppRoute.getAddressPage(),
                                        arguments: AddAddressPage(fromPickAddressPage: true)
                                    );
                                  }
                                }
                              },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
