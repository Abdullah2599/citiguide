import 'package:flutter/material.dart';

IconData getIconForOffer(String offer) {
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
    default:
      return Icons.help; // Fallback icon if the offer is unknown
  }
}
