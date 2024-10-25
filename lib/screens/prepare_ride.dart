
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../helpers/POI.dart';
import '../helpers/shared_funtions.dart';
import '../widgets/carousel_card.dart';
import '../widgets/review_ride_fa_button.dart';

class PrepareRide extends StatefulWidget {
  const PrepareRide({super.key});

  @override
  State<PrepareRide> createState() => _PrepareRideState();

  // Declare a static function to reference setters from children
  static _PrepareRideState? of(BuildContext context) =>
      context.findAncestorStateOfType<_PrepareRideState>();
}

class _PrepareRideState extends State<PrepareRide> {
  bool isLoading = false;
  bool isEmptyResponse = true;
  bool hasResponded = false;
  bool isResponseForDestination = false;

  String noRequest = 'Please enter an address, a place or a location to search';
  String noResponse = 'No results found for the search';

  List responses = [];
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  late MapboxMapController mapController;
  var isLight = true;
  late final LatLng currentLatLng;
  late List<CameraPosition> _POI;
  List<Map> carouselData = [];

  int pageIndex = 0;
  bool accessed = false;
  late List<Widget> carouselItems;



  @override
  void initState()
  {
    super.initState();
    for (int index = 0; index < POI.length; index++) {
      num distance = getDistanceFromSharedPrefs(index) / 1000;
      num duration = getDurationFromSharedPrefs(index) / 60;
      carouselData
          .add({'index': index, 'distance': distance, 'duration': duration});
    }
    //carouselData.sort((a, b) => a['duration'] < b['duration'] ? 0 : 1);

    // Generate the list of carousel widgets
    carouselItems = List<Widget>.generate(
        POI.length,
            (index) => carouselCard(carouselData[index]['index'],
            carouselData[index]['distance'], carouselData[index]['duration']));

    // initialize map symbols in the same order as carousel widgets
    _POI = List<CameraPosition>.generate(
        POI.length,
            (index) => CameraPosition(
            target: getLatLngFromRestaurantData(carouselData[index]['index']),
            zoom: 19));

    setsourceanddestination(carouselData, 0);
  }

  _addSourceAndLineLayer(int index, bool removeLayer) async {
    // Can animate camera to focus on the item
    mapController.animateCamera(CameraUpdate.newCameraPosition(_POI[index]));

    // Add a polyLine between source and destination
    Map geometry = getGeometryFromSharedPrefs(carouselData[index]['index']);
    final fills = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          "properties": <String, dynamic>{},
          "geometry": geometry,
        },
      ],
    };

    // Remove lineLayer and source if it exists
    if (removeLayer == true) {
      await mapController.removeLayer("lines");
      await mapController.removeSource("fills");
    }

    // Add new source and lineLayer
    await mapController.addSource(
        "fills", GeojsonSourceProperties(data: fills));
    await mapController.addLineLayer(
      "fills",
      "lines",
      LineLayerProperties(
        lineColor: Colors.green.toHexStringRGB(),
        lineCap: "round",
        lineJoin: "round",
        lineWidth: 2,
      ),
    );
  }

  _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  _onStyleLoadedCallback() async {
    for (CameraPosition _kRestaurant in _POI) {
      await mapController.addSymbol(
        SymbolOptions(
          geometry: _kRestaurant.target,
          iconSize: 0.2,
          iconImage: "assets/icon/food.png",
        ),
      );
    }
    _addSourceAndLineLayer(0, false);
  }

  // Define setters to be used by children widgets
  set responsesState(List responses) {
    setState(() {
      this.responses = responses;
      hasResponded = true;
      isEmptyResponse = responses.isEmpty;
    });
    Future.delayed(
      const Duration(milliseconds: 500),
      () => setState(() {
        isLoading = false;
      }),
    );
  }

  set isLoadingState(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  set isResponseForDestinationState(bool isResponseForDestination) {
    setState(() {
      this.isResponseForDestination = isResponseForDestination;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back)),
        title: const Text('SVCENav'),
        actions: const [
          //CircleAvatar(backgroundImage: AssetImage('assets/image/person.jpg')),
        ],
      ),
      body: SafeArea(
        child: Stack(children: [
          MapboxMap(
            styleString:
            isLight ? MapboxStyles.MAPBOX_STREETS : MapboxStyles.DARK,
            accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
                target: LatLng(12.986908, 79.972217), zoom: 15),
            onStyleLoadedCallback: _onStyleLoadedCallback,
            myLocationEnabled: true,
            myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
            //minMaxZoomPreference: const MinMaxZoomPreference(14, 20),
          ),
          CarouselSlider(
            items: carouselItems,
            options: CarouselOptions(
              height: 100,
              viewportFraction: 0.6,
              initialPage: 0,
              enableInfiniteScroll: false,
              scrollDirection: Axis.horizontal,
              onPageChanged:
                  (int index, CarouselPageChangedReason reason) async {
                setState(()  {
                  pageIndex = index;
                  setsourceanddestination(carouselData, index);
                });
                _addSourceAndLineLayer(index, true);
              },
            ),
          ),
        ]),
      ),
      floatingActionButton: reviewRideFaButton(context),
    );
  }
}
