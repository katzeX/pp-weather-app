import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pp_weather_app/model/weather_forecast_response.dart';
import 'package:pp_weather_app/service/weather_service.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'model/weather_response.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (!kIsWeb) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _cityTextController = TextEditingController();
  final _weatherService = WeatherService();

  WeatherResponse _response;
  List<WeatherForecastResponse> _forecastResponse;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Weather-App',
        home: Scaffold(
            body: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_response != null)
              Column(
                children: [
                  Image.network(_response.iconUrl),
                  Text(
                    '${_response.temperature.temperature}°C',
                    style: TextStyle(fontSize: 40),
                  ),
                  Text(_response.weather.description)
                ],
              ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: SizedBox(
                width: 150,
                child: TextField(
                  controller: _cityTextController,
                  decoration: InputDecoration(
                      labelText: 'City',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                  textAlign: TextAlign.center,
                  cursorColor: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _search,
              child: Text('Search'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
            ),
            if (_forecastResponse != null)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      _forecastResponse.map((e) => forecastElement(e)).toList(),
                ),
              ),
          ],
        ))));
  }

  void _search() async {
    final response = await _weatherService.getWeather(_cityTextController.text);
    final forecastResponse =
        await _weatherService.getWeatherForecast(response.coordinates);
    setState(
        () => {_response = response, _forecastResponse = forecastResponse});
  }

  void firebaseOnMessage() {
    FirebaseMessaging.instance.getToken().then(print);
    FirebaseMessaging.onMessage.listen((event) {
      if (event != null) {
        final title = event.notification.title;
        final body = event.notification.body;

        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.all(18),
                children: [Text('$title'), Text('$body')],
              );
            });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channel.description,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                ),
              ));
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification?.android;
        if (notification != null && android != null) {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text(notification.title),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(notification.body)],
                    ),
                  ),
                );
              });
        }
      });
    } else {
      firebaseOnMessage();
    }
  }
}

Widget forecastElement(WeatherForecastResponse response) {
  var date = response.dateTime;

  return Padding(
    padding: const EdgeInsets.only(left: 16.0, top: 25.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Text(
              new DateFormat.E().format(date),
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            Text(
              new DateFormat.MMMd().format(date),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Image.network(
                response.iconUrl,
                width: 50,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  response.weather.description,
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                )),
            Text(
              '${response.temperature.temperature.toString()} °C',
              style: TextStyle(color: Colors.white, fontSize: 15.0),
            )
          ],
        ),
      ),
    ),
  );
}
