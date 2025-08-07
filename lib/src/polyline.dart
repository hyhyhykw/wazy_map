import 'latlng.dart';

class Polyline {
  String id;
  PolylineOptions options;

  Polyline({required this.id, required this.options});

  factory Polyline.fromJson(Map<String, dynamic> json) {
    // final latitude = double.tryParse(json['latitude'].toString()) ?? 0;
    // final longitude = double.tryParse(json['longitude'].toString()) ?? 0;
    Map optionsJson = json['options'];
    return Polyline(
      id: json['id'],
      options: PolylineOptions.fromJson(optionsJson.cast()),
    );
  }

  Map<String, dynamic> toParams() {
    return {
      'id': id,
      'options': options.toParams(),
    };
  }
}

class PolylineOptions {
  final List<LatLng> points;
  double width;
  String color;
  double zIndex;

  bool isDottedLine;
  bool isVisible;
  String id;

  PolylineOptions({
    this.color = "#000000",
    this.width = 10,
    this.zIndex = 0,
    this.isVisible = true,
    this.isDottedLine = false,
    required this.id,
    required this.points,
  });

  factory PolylineOptions.fromJson(Map<String, dynamic> json) {
    // final latitude = double.tryParse(json['latitude'].toString()) ?? 0;
    // final longitude = double.tryParse(json['longitude'].toString()) ?? 0;
    List pointsJson = json['points'];
    final points = pointsJson.cast<Map>().map((e) {
      return LatLng.fromJson(e.cast());
    }).toList();
    return PolylineOptions(
      id: json['id'],
      points: points,
      color: json['color'],
      width: json['width'],
      zIndex: json['zIndex'],
      isVisible: json['isVisible'],
      isDottedLine: json['isDottedLine'],
    );
  }

  Map<String, dynamic> toParams() {
    final pointsJson = points.map((e) => e.toJson()).toList();
    return {
      'color': color,
      'width': width,
      'zIndex': zIndex,
      'isVisible': isVisible,
      'isDottedLine': isDottedLine,
      'id': id,
      'points': pointsJson
    };
  }
}
