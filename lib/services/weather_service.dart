import "dart:convert";
import 'package:tuple/tuple.dart';

import "package:flutter/material.dart";
import "package:geocoding/geocoding.dart";
import "package:geolocator/geolocator.dart";
import "package:http/http.dart" as http;
import "package:newweatherapp/models/weather.dart";

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String api_key;

  WeatherService(this.api_key);

  Future<Weather> getWeather(String lat, String lon) async {
    final response =
        await http.get(Uri.parse('$BASE_URL?lat=$lat&lon=$lon&appid=$api_key'));
    if (response.statusCode == 200) {
      // işlem başarılı
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error while loading weather data!");
    }
  }

  Future<Tuple2> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    // izin isteme yeri
    if (permission == LocationPermission.denied) {
      // izin verilmemiş tekrar izin iste
      await Geolocator.requestPermission();
    }
    // Cihazın tam konumunu alma yeri
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // enlem ve boylamı kullanarak placemark objesi yaptık
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    // ilk placemarkın ismini aldık
    String? city = placemarks[0].administrativeArea;
    return Tuple2(position.latitude, position.longitude);
  }
}
