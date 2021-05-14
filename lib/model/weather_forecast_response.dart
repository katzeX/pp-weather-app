import 'package:pp_weather_app/model/temperature.dart';
import 'package:pp_weather_app/model/weather.dart';

class WeatherForecastResponse {
  final Temperature temperature;
  final Weather weather;
  final DateTime dateTime;

  WeatherForecastResponse({this.temperature, this.weather, this.dateTime});

  String get iconUrl {
    return 'https://openweathermap.org/img/wn/${weather.icon}@2x.png';
  }

  factory WeatherForecastResponse.fromJson(Map<String, dynamic> json) {
    return WeatherForecastResponse(
        temperature: Temperature.fromJsonComplex(json),
        dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
        weather: Weather.fromJson(json['weather'][0]));
  }
}
