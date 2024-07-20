class Weather {
  final String cityName;
  final double temperature;
  final String condition;

  Weather(
      {required this.cityName,
      required this.temperature,
      required this.condition});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json["name"] ?? "Bilinmeyen Şehir",
      temperature: ((json["main"]["temp"] as num?)?.toDouble() ?? 0.0) -
          273.15, // Kelvin'den Celsius'a çevirme
      condition: json["weather"][0]["main"] ?? "Bilinmeyen Durum",
    );
  }
}
