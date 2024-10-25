import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:navi/helpers/mapbox_handler.dart';
import 'package:navi/helpers/shared_prefs.dart';

import '../screens/review_ride.dart';

Widget reviewRideFaButton(BuildContext context) {
  return FloatingActionButton.extended(
      icon: const Icon(Icons.local_taxi),
      onPressed: () async {
        // Get directions API response and pass to modified response
        LatLng sourceLatLng = getTripLatLngFromSharedPrefs('source');
        LatLng destinationLatLng = getTripLatLngFromSharedPrefs('destination');
        Map modifiedresponse = await getDirectionsAPIResponse(sourceLatLng, destinationLatLng);


        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ReviewRide(modifiedResponse: modifiedresponse)));
      },
      label: const Text('Review Ride'));
}
