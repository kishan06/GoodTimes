// ignore_for_file: body_might_complete_normally_catch_error

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../view-models/global_controller.dart';
import '../data/repository/services/user_location_data.dart';

LatLng? latlong;

class LocationController {
  final GlobalController globalController = Get.find();

  Future<void> getCurrentLocation(BuildContext context) async {
    Position position;
    try {
      position = await getUserCurrentLocation();
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      globalController.locationName.value =
          placemarks.isNotEmpty ? placemarks[0].locality ?? '' : '';
      log("user location data latitude ${position.latitude} longitude ${position.longitude}");
      UserLocationService().userLocationData(context,
          latitude: position.latitude, longitude: position.longitude);
    } catch (e) {
      log('Error getting user location: $e');
    }
  }

  Future<Map<String, double>> userCurrentPosition() async {
    Position position;
    try {
      position = await getUserCurrentLocation();
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      globalController.locationName.value =
          placemarks.isNotEmpty ? placemarks[0].locality ?? '' : '';
      log("user location data latitude ${position.latitude} longitude ${position.longitude}");

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    } catch (e) {
      log('Error getting user location: $e');
      return {};
    }
  }

  Future<Position> getUserCurrentLocation({bool redirect = false}) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      if (redirect) {
        await Geolocator.openAppSettings().then((value) async {
          Position currentP = await Geolocator.getCurrentPosition();
          latlong = LatLng(currentP.latitude, currentP.longitude);

          return currentP;
        });
      }

      throw 'Location permission permanently denied';
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position currentP = await Geolocator.getCurrentPosition();
      latlong = LatLng(currentP.latitude, currentP.longitude);

      return currentP;
    } else {
      throw 'Location permission denied';
    }
  }
}
