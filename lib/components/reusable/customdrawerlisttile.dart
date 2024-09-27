import 'package:CityNavigator/Theme/color.dart';
import 'package:flutter/material.dart';


Widget customDrawerlistTile({
  required String title,
  required IconData icon,
  required VoidCallback? onTap,
  badgenumber
}) {
  return ListTile(
              onTap: onTap,
              title: Text(title,style: TextStyle(color: Colors.black)),
              leading: Icon(icon,color: ColorTheme.primaryColor),
              trailing: SizedBox(
                height: 25,
                width: 25,
                child: badgenumber == null ? null : Badge(
                  backgroundColor: ColorTheme.primaryColor,
                  label: Text(badgenumber,style: TextStyle(color: Colors.black),),
                ),),
            );
}