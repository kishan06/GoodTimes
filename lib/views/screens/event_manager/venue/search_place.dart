import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:get/get.dart';
import 'package:good_times/utils/constant.dart';
import 'package:google_api_headers/google_api_headers.dart';

import '../../../../view-models/global_controller.dart';
import '../../../widgets/common/bottom_sheet.dart';
import '../../../widgets/common/parent_widget.dart';
import 'custome_address_venue.dart';

const kGoogleApiKey = 'AIzaSyCQv-Cfzkh3cXerrui55oId7CDHhuIImhc';
final GlobalController globalcontroller = Get.put(GlobalController());

class SearchPlace extends PlacesAutocompleteWidget {
  SearchPlace({Key? key})
      : super(
          key: key,
          apiKey: kGoogleApiKey,
          language: 'en',
          components: [
            const Component(Component.country, "uk"),
            // const Component(Component.country, "fr"), // France
            // const Component(Component.country, "de"), // Germany
            // const Component(Component.country, "es"), // Spain
            // const Component(Component.country, "it"), // Italy
          ],
        );

  @override
  _SearchPlaceState createState() => _SearchPlaceState();
}

class _SearchPlaceState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    return parentWidgetWithConnectivtyChecker(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: kPrimaryColor),
            title: const AppBarPlacesAutoCompleteTextField(
              textStyle: TextStyle(color: kTextWhite),
              textDecoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryColor),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryColor),
                ),
                errorStyle: TextStyle(fontSize: 14.0),
              ),
              cursorColor: kPrimaryColor,
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: PlacesAutocompleteResult(
                  onTap: (p) {
                    displayPrediction(p, ScaffoldMessenger.of(context));
                    Get.back();
                    log('locations data controller ${p.description.runtimeType}');
                    globalcontroller.address.value = p.description!;
                  },
                  logo: const SizedBox(),
                  resultTextStyle: paragraphStyle,
                ),
              ),
              const Divider(),
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, VenueCustomAddress.routeName);
                },
                child: Container(
                  decoration: const BoxDecoration(),
                  child: Row(
                    children: [
                      const Icon(Icons.add, color: kPrimaryColor, size: 30),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Can't find what you are looking for?",
                            style: labelStyle.copyWith(fontWeight: FontWeight.w500,fontSize: 16),
                          ),
                           Text(
                            "Add a new venue or address.",
                            style: paragraphStyle.copyWith(fontSize: 14),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage ?? 'Unknown error')),
    );
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);

    if (response.predictions.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Got answer')),
      );
    }
  }
}

Future<void> displayPrediction(
    Prediction? p, ScaffoldMessengerState messengerState) async {
  if (p == null) {
    return;
  }

  // get detail (lat/lng)
  final _places = GoogleMapsPlaces(
    apiKey: kGoogleApiKey,
    apiHeaders: await const GoogleApiHeaders().getHeaders(),
  );

  final detail = await _places.getDetailsByPlaceId(p.placeId!);
  final geometry = detail.result.geometry!;
  final lat = geometry.location.lat;
  final lng = geometry.location.lng;
  globalcontroller.address.value = p.description.toString();
  globalcontroller.long.value = lng.toString();
  globalcontroller.lat.value = lat.toString();
  log("location details get ${globalcontroller.address.value} lat ${globalcontroller.lat.value} lng ${globalcontroller.long.value}");


  customAddressForVenue(context){
    return modalBottomShetWidget(
      context,
      title: 'Manager Profile',
      defaultHeight: MediaQuery.of(context).size.height * 0.7,
      child: StatefulBuilder(builder: (context, setStates) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: scaffoldPadding),
          child: VenueCustomAddress()
        );
      }),
    );
  }
}
