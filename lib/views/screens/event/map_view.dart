// ignore_for_file: unnecessary_null_comparison, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:good_times/data/repository/endpoints.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../Globalconstant/constant.dart';

class MapViews extends StatefulWidget {
  final LatLng? eventLocation;
  const MapViews({this.eventLocation, super.key});

  @override
  State<MapViews> createState() => _MapViewsState();
}

class _MapViewsState extends State<MapViews> {
  LatLng? _pCurrentPlace;
  late StreamController<LatLng> _latLngStreamController;
  StreamSubscription<Position>? _positionStream;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  final Completer<GoogleMapController> _mapContoller =
      Completer<GoogleMapController>();
  String googleApiKey = "AIzaSyDdTfKwZav5Qyg3ht88N76lDTFntOe30dQ";

  Map<PolylineId, Polyline> polylines = {};
  @override
  void initState() {
    _latLngStreamController = StreamController<LatLng>();
    _fetchLocation();
    // addCustomIcon();
    super.initState();
  }


  _fetchLocation() async {
    await getUserCurrentLocation().then((value) {
      _latLngStreamController.sink.add(LatLng(value.latitude, value.longitude));
      getLocationUpdates().then((_) {
        getPolyLine().then((coordinates) {
          logger.f("coordinates $coordinates");
          genratedPolylineFromPoints(coordinates);
        });
      });
    });
  }

  void addCustomIcon() {
    BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(30, 30)),
      "assets/images/avatar.jpg",
    ).then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      // await Geolocator.requestPermission();
      // log("ERROR $error");
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    LocationPermission _permission;
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (_permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position currntPosition) {
      if (currntPosition.latitude != null && currntPosition != null) {
        logger.f(
            'positionStream Latitude: ${currntPosition.latitude}, Longitude: ${currntPosition.longitude}');
        setState(() {
          _pCurrentPlace =
              LatLng(currntPosition.latitude, currntPosition.longitude);
        });
        log("_pCurrentPlace $_pCurrentPlace");
        _cameraPosition(_pCurrentPlace!);
      }
    });
  }

  @override
  void dispose() {
    _latLngStreamController.close(); // Close the stream when disposing.
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("check location in log ${widget.eventLocation}");
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text(""),
      ),
      body: StreamBuilder(
        stream: _latLngStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Display a loading indicator when waiting for data.
          } else if (snapshot.hasError) {
            return Text(
                'Error: ${snapshot.error}'); // Display an error message if an error occurs.
          } else if (!snapshot.hasData) {
            return const Text(
                'No data available'); // Display a message when no data is available.
          } else {
            log("location data with streambuilder ${snapshot.data!}");
            LatLng data = snapshot.data!;
            _pCurrentPlace = data;

            return GoogleMap(
                onMapCreated: ((GoogleMapController controller) =>
                    _mapContoller.complete(controller)),
                initialCameraPosition: CameraPosition(
                  target: _pCurrentPlace!,
                  zoom: 12,
                ),
                markers: {
                  globaldestinationmarkers!,
                  Marker(
                    markerId: const MarkerId("_destinationLocation"), //apple
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue),
                    position: _pCurrentPlace!,
                  ),
                },
                polylines: Set<Polyline>.of(polylines.values));
          }
        },
      ),
    );
  }

  //* get current possition for the update the marker update
  Future<void> _cameraPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapContoller.future;

    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 13);

    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  Future<List<LatLng>> getPolyLine() async {
    List<LatLng> polylineCoorinated = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        PointLatLng(
            widget.eventLocation!.latitude, widget.eventLocation!.longitude),
        PointLatLng(_pCurrentPlace!.latitude, _pCurrentPlace!.longitude),
        travelMode: TravelMode.driving);

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoorinated.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      logger
          .e("polyline error while getting coordinates ${result.errorMessage}");
    }
    return polylineCoorinated;
  }

  void genratedPolylineFromPoints(List<LatLng> polylineCoorddinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue.shade400,
        points: polylineCoorddinates,
        width: 5);
    setState(() {
      polylines[id] = polyline;
    });
  }
}
