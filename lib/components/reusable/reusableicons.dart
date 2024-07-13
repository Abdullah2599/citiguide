import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
getIconForOffer(String offer) {
  switch (offer) {
    case 'Fee Dining':
      return Icons.food_bank;
    case 'Bar':
      return Icons.local_bar;
    case 'Parking':
      return Icons.local_parking;
    case 'Fast Food':
      return Icons.fastfood;
    case 'WiFi':
      return Icons.wifi;
    case 'Pool':
      return Icons.pool;
    case 'Games':
      return Icons.games;
    case 'Museum':
      return Icons.museum;
    case 'Cafe':
      return Icons.coffee;
    case 'Library':
      return Icons.book;
    case 'Zoo':
      return Icons.forest;
    case 'ATM':
      return Icons.atm;
    case 'Subway':
      return Icons.subway;
    case 'Air Conditioned':
      return Icons.ac_unit;
    case 'Shopping':
      return Icons.shopping_bag;
    case 'Food Stalls':
      return Icons.food_bank;
    case 'Mosque':
      return Icons.mosque;
    case 'Church':
      return Icons.church;
    case 'Temple':
      return Icons.temple_buddhist;
    case 'Child Care':
      return Icons.child_care;
    case 'Playing Area':
      return Icons.park;
    case 'Tickets':
      return Icons.receipt;
    case 'Hiking':
      return Icons.hiking;
    case 'Farm Houses':
      return Icons.other_houses;
    case 'Cruise':
      return Icons.directions_boat;
    case 'Park':
      return Icons.park;
      //  case 'Sea Food':
      // return SvgIcon(icon: Icons.);

    default:
      return Icons.help;
  }
}
