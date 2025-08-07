import 'latlng.dart';

class Polygon {
  String id;
  PolygonOptions options;

  Polygon({required this.id, required this.options});

  factory Polygon.fromJson(Map<String, dynamic> json) {
    // final latitude = double.tryParse(json['latitude'].toString()) ?? 0;
    // final longitude = double.tryParse(json['longitude'].toString()) ?? 0;
    Map optionsJson = json['options'];
    return Polygon(
      id: json['id'],
      options: PolygonOptions.fromJson(optionsJson.cast()),
    );
  }

  Map<String, dynamic> toParams() {
    return {
      'id': id,
      'options': options.toParams(),
    };
  }
}

class PolygonOptions {
  final List<LatLng> points;
  double strokeWidth;
  String fillColor;
  String strokeColor;
  double zIndex;

  bool isDottedLine;
  bool isVisible;
  String id;

  PolygonOptions({
    this.fillColor = "#00000000",
    this.strokeColor = "#000000",
    this.strokeWidth = 10,
    this.zIndex = 0,
    this.isVisible = true,
    this.isDottedLine = false,
    required this.id,
    required this.points,
  });

  factory PolygonOptions.fromJson(Map<String, dynamic> json) {
    // final latitude = double.tryParse(json['latitude'].toString()) ?? 0;
    // final longitude = double.tryParse(json['longitude'].toString()) ?? 0;
    List pointsJson = json['points'];
    final points = pointsJson.cast<Map>().map((e) {
      return LatLng.fromJson(e.cast());
    }).toList();
    return PolygonOptions(
      id: json['id'],
      points: points,
      fillColor: json['fillColor'],
      strokeColor: json['strokeColor'],
      strokeWidth: json['strokeWidth'],
      zIndex: json['zIndex'],
      isVisible: json['isVisible'],
      isDottedLine: json['isDottedLine'],
    );
  }

  Map<String, dynamic> toParams() {
    final pointsJson = points.map((e) => e.toJson()).toList();
    return {
      'fillColor': fillColor,
      'strokeColor': strokeColor,
      'strokeWidth': strokeWidth,
      'zIndex': zIndex,
      'isVisible': isVisible,
      'isDottedLine': isDottedLine,
      'id': id,
      'points': pointsJson
    };
  }
}
