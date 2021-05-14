class Temperature {
  final double temperature;

  Temperature({this.temperature});

  Temperature.withMyParam(this.temperature);

  factory Temperature.fromJson(Map<String, dynamic> json) {
    final temperature = json['temp'];
    return Temperature(temperature: temperature + .0);
  }

  factory Temperature.fromJsonComplex(Map<String, dynamic> json) {
    final temperature = json['temp']['day'];
    return Temperature(temperature: temperature);
  }
}
