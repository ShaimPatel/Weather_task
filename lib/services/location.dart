import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer' as developer;

class Location {
  double? latitude;
  double? longitude;

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print(e.toString());
      developer.log("Not Working");
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
