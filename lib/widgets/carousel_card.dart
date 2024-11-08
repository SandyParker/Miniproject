import 'package:flutter/material.dart';

import '../helpers/POI.dart';

Widget carouselCard(int index, num distance, num duration) {
  return Card(
    color: Color(0xff404258),
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(POI[index]['image']),//NetworkImage(POI[index]['image']),
            radius: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  POI[index]['name'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16,
                      color: Color(0xFFABAED2)),
                ),
                //Text(POI[index]['items'],
                    //overflow: TextOverflow.ellipsis),
                const SizedBox(height: 5),
                Text(
                  '${distance.toStringAsFixed(2)}kms, ${duration.toStringAsFixed(2)} mins',
                  style: const TextStyle(color: Color(0xFF6B728E)),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}