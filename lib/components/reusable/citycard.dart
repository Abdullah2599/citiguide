import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

CityCard({required cityimg, required cityname}) {
  return Card(
    elevation: 20,
    child: Stack(
      children: [
        // Opacity(
          // opacity: 0.9,
          // child:
           ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            child: CachedNetworkImage(
              imageUrl: cityimg,
              height: 500,
              fit: BoxFit.cover,
            ),
          ),
        // ),
        Positioned(
            bottom: 10,
            left: 30,
            child: Text(
              cityname,
              style: TextStyle(fontSize: 24, color: Colors.white),
            ))
      ],
    ),
  );
}
