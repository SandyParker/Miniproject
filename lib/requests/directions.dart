
import 'package:mapbox_gl/mapbox_gl.dart';
//import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

import '../helpers/POI.dart';
import '../main.dart';
//import 'package:navi/requests/mapbox_directions.dart';
import 'mapbox_requests.dart';

Future<Map> getDirectionsAPIResponse(LatLng currentLatLng, int index) async {
  final response = await getCyclingRouteUsingMapbox(
      currentLatLng,
      LatLng(double.parse(POI[index]['coordinates']['latitude']),
          double.parse(POI[index]['coordinates']['longitude'])));
  Map geometry = response['routes'][0]['geometry'];
  num duration = response['routes'][0]['duration'];
  num distance = response['routes'][0]['distance'];
  print('-------------------${POI[index]['name']}-------------------');
  print(distance);
  print(duration);

  Map modifiedResponse = {
    "geometry": geometry,
    "duration": duration,
    "distance": distance,
  };
  return modifiedResponse;
}

void saveDirectionsAPIResponse(int index, String response) {
  sharedPreferences.setString('restaurant--$index', response);
}