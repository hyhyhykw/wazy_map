import 'latlng.dart';

class Circle {
  String id;
  CircleOptions options;

  Circle({required this.id, required this.options});

  factory Circle.fromJson(Map<String, dynamic> json) {
    // final latitude = double.tryParse(json['latitude'].toString()) ?? 0;
    // final longitude = double.tryParse(json['longitude'].toString()) ?? 0;
    Map optionsJson = json['options'];
    return Circle(
      id: json['id'],
      options: CircleOptions.fromJson(optionsJson.cast()),
    );
  }

  Map<String, dynamic> toParams() {
    return {
      'id': id,
      'options': options.toParams(),
    };
  }
}

class CircleOptions {
  double radius;
  String fillColor;
  String strokeColor;
  double strokeWidth;
  double zIndex;
  bool isVisible;
  bool isDottedLine;
  LatLng center;
  String id;

  CircleOptions({
    this.radius = 10,
    this.fillColor = "#00000000",
    this.strokeColor = "#000000",
    this.strokeWidth = 1,
    this.zIndex = 0,
    this.isVisible = true,
    this.isDottedLine = false,
    required this.id,
    required this.center,
  });

  factory CircleOptions.fromJson(Map<String, dynamic> json) {
    // final latitude = double.tryParse(json['latitude'].toString()) ?? 0;
    // final longitude = double.tryParse(json['longitude'].toString()) ?? 0;
    Map centerJson = json['center'];
    return CircleOptions(
      id: json['id'],
      center: LatLng.fromJson(centerJson.cast()),
      radius: json['radius'],
      fillColor: json['fillColor'],
      strokeColor: json['strokeColor'],
      strokeWidth: json['strokeWidth'],
      zIndex: json['zIndex'],
      isVisible: json['isVisible'],
      isDottedLine: json['isDottedLine'],
    );
  }

  Map<String, dynamic> toParams() {
    return {
      'radius': radius,
      'fillColor': fillColor,
      'strokeColor': strokeColor,
      'strokeWidth': strokeWidth,
      'zIndex': zIndex,
      'isVisible': isVisible,
      'isDottedLine': isDottedLine,
      'id': id,
      'center':center.toJson(),
    };
  }
}
