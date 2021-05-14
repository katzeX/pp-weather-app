class Coordinates {
  final double longitude;
  final double latitude;

  Coordinates({this.longitude, this.latitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    final longitude = json['lon'];
    final latitude = json['lat'];
    return Coordinates(longitude: longitude, latitude: latitude);
  }
}
