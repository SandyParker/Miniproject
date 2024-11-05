import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../helpers/dio_exceptions.dart';


//import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

import '../helpers/POI.dart';
import '../main.dart';
//import 'package:navi/requests/mapbox_directions.dart';

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

String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN']!;
String navType = 'driving';

Dio _dio = Dio();

Future getCyclingRouteUsingMapbox(LatLng source, LatLng destination) async {
  String url =
      '$baseUrl/$navType/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$accessToken';
  try {
    print(url);
    _dio.options.contentType = Headers.jsonContentType;
    final responseData = await _dio.get(url);
    return responseData.data;
  } catch (e) {
    final errorMessage = DioExceptions.fromDioError(e as DioError).toString();
    debugPrint(errorMessage);
  }
}
