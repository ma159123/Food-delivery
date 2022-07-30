import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:food_delivery/data/controller/address_controller.dart';
import 'package:food_delivery/widgets/dimensions.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/src/places.dart';

class LocationDialogue extends StatelessWidget {
  final GoogleMapController mapController;

  const LocationDialogue({Key? key, required this.mapController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Container(
      padding: EdgeInsets.all(Dimensions.width10),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius15 / 3),
        ),
        child: SizedBox(
          width: Dimensions.screenWidth,
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: _controller,
              textInputAction: TextInputAction.search,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintText: 'search location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  borderSide:
                      const BorderSide(style: BorderStyle.none, width: 0),
                ),
                hintStyle: Theme.of(context).textTheme.headline2?.copyWith(
                  color: Theme.of(context).disabledColor,
                  fontSize: Dimensions.font16*1.15,
                ),
              ),
            ),
            itemBuilder: (context, Prediction suggestion) {
              return Row(
                children: [
                  const Icon(Icons.location_on),
                  Expanded(
                    child: Text(
                      suggestion.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline2?.copyWith(
                          color: Theme.of(context).textTheme.bodyText1?.color,
                          fontSize: Dimensions.font16,
                      ),
                    ),
                  ),
                ],
              );
            },
            onSuggestionSelected: (Prediction suggestion) {
              Get.find<AddressController>().setLocation(suggestion.placeId!, suggestion.description!, mapController);
           Get.back();
            },
            suggestionsCallback: (pattern) async {
              return await Get.find<AddressController>()
                  .searchLocation(context, pattern);
            },
          ),
        ),
      ),
    );
  }
}
