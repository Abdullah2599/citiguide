import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class citymodel {
  String cimg;
  String cname;
  citymodel({required this.cimg, required this.cname});
}

CityCard({required cityimg, required cityname}) {
  return Card(
    elevation: 20,
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          child: CachedNetworkImage(
            imageUrl: cityimg,
            height: 500,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 10,
          left: 12,
          child: Stack(
            children: <Widget>[
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
        )
      ],
    ),
  );
}
