import 'package:flutter/material.dart';
import 'package:navi/helpers/shared_funtions.dart';
import 'package:navi/helpers/shared_prefs.dart';

import '../screens/turn_by_turn.dart';

Widget reviewRideBottomSheet(
    BuildContext context, String distance, String dropOffTime) {
  // Get source and destination addresses from sharedPreferences
  String sourceAddress = getSourceAndDestinationPlaceText('source');
  String destAddress  = getSourceAndDestinationPlaceText('destination');

  return Positioned(
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
                Center(
                  child: Text(getdestinationName() as String,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Color(0xFFABAED2))),
                ),
                /*Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    tileColor: Colors.grey[200],
                    leading: const Image(
                        image: AssetImage('assets/image/sport-car.png'),
                        height: 50,
                        width: 50),
                    title: const Text('Premier',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text('$distance km, $dropOffTime drop off'),
                    trailing: const Text('\$384.22',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ),*/
                SizedBox(),
                ElevatedButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const TurnByTurn())),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black12,
                    foregroundColor: Color(0xFFABAED2),
                        padding: const EdgeInsets.all(20)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Confrim Navigation',style: TextStyle(color: Color(0xFFABAED2)),),
                        ])),
              ]),
        ),
      ),
    ),
  );
}
