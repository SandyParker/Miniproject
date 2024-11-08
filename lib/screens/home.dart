import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:navi/helpers/shared_prefs.dart';
import 'package:navi/screens/prepare_ride.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  LatLng currentLocation = getCurrentLatLngFromSharedPrefs();
  late CameraPosition _initialCameraPosition;
  late String currentAddress;

  @override
  void initState() {
    super.initState();
    //print("Working?");
    _initialCameraPosition = CameraPosition(target: currentLocation, zoom: 14);
    currentAddress = getCurrentAddressFromSharedPrefs();
    //print("After");
    // Set initial camera position and current address
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Add MapboxMap here and enable user location
          MapboxMap(initialCameraPosition: _initialCameraPosition,
            styleString: 'mapbox://styles/sandy-parker/clmkof8hw01vn01r79wf332cu',
            accessToken: dotenv.env["MAPBOX_ACCESS_TOKEN"],
            myLocationEnabled: true,
              minMaxZoomPreference: const MinMaxZoomPreference(10, 25)
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Card(
                color: Color(0xff404258),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Hi there!',
                        style: TextStyle(
                          color: Color(0xFFABAED2),
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const Text('You are currently here:',
                      style: TextStyle(color: Color(0xFFABAED2)),),
                      Text(currentAddress,
                          style: const TextStyle(color: Color(0xFF8286B4))),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const PrepareRide())),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black12,
                            padding: const EdgeInsets.all(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Where do you wanna go today?', style: TextStyle(color: Color(0xFFABAED2)),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
