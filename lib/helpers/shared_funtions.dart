import 'dart:convert';

import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

//import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

import '../main.dart';
import 'POI.dart';
import 'mapbox_handler.dart';
//import 'full_map.dart';
//import 'main.dart';

Location _location = Location();

LatLng getLatLngFromSharedPrefs() {
  return LatLng(sharedPreferences.getDouble('latitude')!,
      sharedPreferences.getDouble('longitude')!);
}

Map getDecodedResponseFromSharedPrefs(int index) {
  String key = 'restaurant--$index';
  Map response = json.decode(sharedPreferences.getString(key)!);
  return response;
}

num getDistanceFromSharedPrefs(int index) {
  num distance = getDecodedResponseFromSharedPrefs(index)['distance'];
  return distance;
}

num getDurationFromSharedPrefs(int index) {
  num duration = getDecodedResponseFromSharedPrefs(index)['duration'];
  return duration;
}

Map getGeometryFromSharedPrefs(int index) {
  Map geometry = getDecodedResponseFromSharedPrefs(index)['geometry'];
  return geometry;
}

LatLng getLatLngFromRestaurantData(int index) {
  return LatLng(double.parse(POI[index]['coordinates']['latitude']),
      double.parse(POI[index]['coordinates']['longitude']));
}

Future<void> setsourceanddestination(List<Map> carouselData, int index) async {
  LocationData locationData = await _location.getLocation();
  LatLng currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
  var response = await getParsedReverseGeocoding(currentLocation);
  sharedPreferences.setString('source', jsonEncode(response));
  print(sharedPreferences.getString('source'));
  LatLng destination = getLatLngFromRestaurantData(carouselData[index]['index']);
  var destresponse = await getParsedReverseGeocoding(destination);
  sharedPreferences.setString('destination',  jsonEncode(destresponse));
  sharedPreferences.setString('destinationName', POI[index]['name']);
  print(sharedPreferences.getString('destination'));
}

String? getdestinationName()
{
  return sharedPreferences.getString('destinationName');
}