import 'package:cached_network_image/cached_network_image.dart';
import 'package:citiguide/Theme/color.dart';
import 'package:flutter/material.dart';

Widget customEvents(
    {required String imageurl,
    required String title,
    required String description,
    onTap,
    onDTap}) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorTheme.primaryColor, width: 2.0)),
    height: 150,
    width: 320,
    child: Stack(
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: imageurl,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
            top: 20,
            left: 8,
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white),
            )),
        Positioned(
          top: 50,
          left: 8,
          right: 12,
          child: Container(
            height: 80,
            width: 40,
            child: Text(
              description,
              style: TextStyle(
                color: Colors.white,
              ),
              softWrap: true,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Positioned(
            top: 50,
            right: 8,
            child: Row(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                            onPressed: onTap,
                            child: Text(
                              'Email Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              backgroundColor: ColorTheme.primaryColor,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),

                              // shape: ,
                            )),
                        ElevatedButton(
                            onPressed: onDTap,
                            child: Text(
                              'Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              backgroundColor: ColorTheme.primaryColor,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),

                              // shape: ,
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ))
      ],
    ),
  );
}
