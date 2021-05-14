class Weather {
  final String description;
  final String icon;

  Weather({this.description, this.icon});

  Weather.withMyParam(this.description, this.icon);

  factory Weather.fromJson(Map<String, dynamic> json) {
    final description = json['description'];
    final icon = json['icon'];
    return Weather(description: description, icon: icon);
  }
}
