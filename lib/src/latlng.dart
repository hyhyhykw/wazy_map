import 'dart:convert';

class LatLng {
  final double latitude;
  final double longitude;

  LatLng({
    required this.latitude,
    required this.longitude,
  });

  factory LatLng.fromJson(Map<String, dynamic> json) {
    final latitude = double.tryParse(json['latitude'].toString()) ?? 0;
    final longitude = double.tryParse(json['longitude'].toString()) ?? 0;
    return LatLng(latitude: latitude, longitude: longitude);
  }

  Map<String, dynamic> toJson() {
    return {
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
