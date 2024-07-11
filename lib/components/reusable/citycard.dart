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
          left: 12,
          child: Stack(
            children: <Widget>[
              // Stroked text as border.
              Text(
                cityname,
                style: TextStyle(
                  fontSize: 22,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Colors.black,
                ),
              ),
              // Solid text as fill.
              Text(
                cityname,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // child: Text(
          //   cityname,
          //   style: TextStyle(
          //     fontSize: 24,
          //     color: Colors.white,
          //     foreground: Paint()
          //       ..style = PaintingStyle.stroke
          //       ..strokeWidth = 6
          //       ..color = const Color.fromARGB(255, 0, 0, 0),
          //   ),
          // )
        )
      ],
    ),
  );
}
