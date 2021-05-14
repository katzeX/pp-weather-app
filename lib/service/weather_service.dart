import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pp_weather_app/model/coordinates.dart';
import 'package:pp_weather_app/model/weather_forecast_response.dart';
import 'package:pp_weather_app/model/weather_response.dart';

class WeatherService {
  Future<WeatherResponse> getWeather(String city) async {
    final queryParams = {
      'q': city,
      'appid': '7ac5d010819a7728157723d4685d22fb',
      'units': 'metric'
    };

    final URI =
        Uri.https('api.openweathermap.org', '/data/2.5/weather', queryParams);
    final response = await http.get(URI); //this is async operation

    print(response.body);

    final json = jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
  }

  Future<List<WeatherForecastResponse>> getWeatherForecast(
      Coordinates coordinates) async {
    print(coordinates.latitude);
    print(coordinates.longitude);

    final forecastQueryParams = {
      'lat': coordinates.latitude.toString(),
      'lon': coordinates.longitude.toString(),
      'exclude': 'current,minutely,hourly,alerts',
      'appid': '7ac5d010819a7728157723d4685d22fb',
      'units': 'metric'
    };

    final URI = Uri.https(
        'api.openweathermap.org', '/data/2.5/onecall', forecastQueryParams);
    final response = await http.get(URI); //this is async operation

    List<WeatherForecastResponse> forecasts = <WeatherForecastResponse>[];

    for (int i = 1; i < 8; i++) {
      final r = jsonDecode(response.body)['daily'][i];
      forecasts.add(WeatherForecastResponse.fromJson(r));
    }

    return forecasts;
  }
}
