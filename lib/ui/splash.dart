import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../helpers/POI.dart';
import '../helpers/mapbox_handler.dart';
import '../main.dart';
//import '../requests/directions.dart';
import '../screens/home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    initializeLocationAndSave();
  }

  void initializeLocationAndSave() async {
    // Ensure all permissions are collected for Locations
    Location location = Location();
    bool? serviceEnabled;
    PermissionStatus? permissionGranted;


    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }


    // Get the current user location
    LocationData locationData = await location.getLocation();
    LatLng currentLocation =
        LatLng(locationData.latitude!, locationData.longitude!);

    // Get the current user address

    var currentAddress =
        (await getParsedReverseGeocoding(currentLocation))['place'];
    //print("Working?");
    print(currentAddress);
    LatLng currentLatLng = LatLng(locationData.latitude!, locationData.longitude!);
    print(currentLatLng);
    for (int i = 0; i < POI.length; i++) {
      Map modifiedResponse = await getDirectionsAPIResponsedir(currentLatLng, i);
      saveDirectionsAPIResponse(i, json.encode(modifiedResponse));
    }

    // Store the user location in sharedPreferences
    sharedPreferences.setDouble('latitude', locationData.latitude!);
    sharedPreferences.setDouble('longitude', locationData.longitude!);
    sharedPreferences.setString('current-address', currentAddress);

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => const Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.indigo,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.car_detailed,
            color: Colors.white,
            size: 120,
          ),
          Text(
            'SVCENav',
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
