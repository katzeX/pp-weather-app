import 'package:pp_weather_app/model/coordinates.dart';
import 'package:pp_weather_app/model/temperature.dart';
import 'package:pp_weather_app/model/weather.dart';

class WeatherResponse {
  final String city;
  final Temperature temperature;
  final Weather weather;
  final Coordinates coordinates;

  WeatherResponse({this.city, this.temperature, this.weather, this.coordinates});

  String get iconUrl {
    return 'https://openweathermap.org/img/wn/${weather.icon}@2x.png';
  }

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    final city = json['name'];
    final temperatureFromJson = json['main'];
    final temperature = Temperature.fromJson(temperatureFromJson);

    final weatherFromJson = json['weather'][0];
    final weather = Weather.fromJson(weatherFromJson);

    final coordinatesFromJson = json['coord'];
    final coordinates = Coordinates.fromJson(coordinatesFromJson);

    return WeatherResponse(
        city: city, temperature: temperature, weather: weather, coordinates: coordinates);
  }
}
