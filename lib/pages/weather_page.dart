import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:newweatherapp/models/weather.dart';
import 'package:newweatherapp/services/weather_service.dart';
import 'package:tuple/tuple.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService("afa489a7bffe4c080f04fee63af84ad1");
  Weather? _weather;

  _fetchWeather() async {
    try {
      Tuple2 long_and_lat = await _weatherService.getCurrentCity();
      String latitude = long_and_lat.item1.toString();
      String longitude = long_and_lat.item2.toString();

      final weather = await _weatherService.getWeather(latitude, longitude);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print("Weather_page de hata: $e");
      // Hata durumunda kullanıcıya bilgi vermek için setState kullanabilirsiniz
      setState(() {
        _weather = null;
      });
    }
  }

  String getWeatherAnimation(String? condition) {
    if (condition == null) {
      return "lib/animations/sunny.json";
    }
    switch (condition.toLowerCase()) {
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return "lib/animations/cloudy.json";
      case "rain":
      case "shower":
      case "drizzle":
        return "lib/animations/rainy.json";
      case "thunderstorm":
        return "lib/animations/thunderstorm.json";
      case "clear":
        return "lib/animations/sunny.json";
      default:
        return "lib/animations/sunny.json";
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    // Sistem temasını kontrol et
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Tema bazlı renkler
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.grey[50];
    final textColor = isDarkMode ? Colors.grey[350] : Colors.black;
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.grey[900]));
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Icon(Icons.location_pin, size: 26, color: Colors.grey[400]),
                // şehir ismi
                Text(
                  _weather?.cityName ?? "Loading City...",
                  style: TextStyle(
                      color: textColor, fontSize: 26, fontFamily: "Roboto"),
                ),
              ],
            ),

            // animasyon
            Lottie.asset(getWeatherAnimation(_weather?.condition)),
            // sıcaklık değeri
            Column(
              children: [
                Text(
                  "${_weather?.temperature.round()}°C",
                  style: TextStyle(
                      color: textColor, fontSize: 34, fontFamily: "Roboto"),
                ),
                // hava durumu
                Text(
                  _weather?.condition ?? "Condition",
                  style: TextStyle(
                      color: textColor, fontSize: 16, fontFamily: "Roboto"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
