import 'dart:convert';

import 'package:wazy_map/src/latlng.dart';

class Marker {
  String id;
  LatLng lat;
  MarkerOptions options;

  Marker({required this.id, required this.lat, required this.options});

  factory Marker.fromJson(Map<String, dynamic> json) {
    // final latitude = double.tryParse(json['latitude'].toString()) ?? 0;
    // final longitude = double.tryParse(json['longitude'].toString()) ?? 0;
    Map latJson = json['lat'];
    Map optionsJson = json['options'];
    return Marker(
      id: json['id'],
      lat: LatLng.fromJson(latJson.cast()),
      options: MarkerOptions.fromJson(optionsJson.cast()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "lat": lat.toJson(),
      "options": options.toParams(),
    };
  }
}

class MarkerOptions {
  String snippet;
  LatLng position;
  String title;
  Map<String, dynamic> params;
  bool isDraggable;

  String id;
  String iconPath;
  bool isFile;

  //IOS 参数
  int width;
  int height;

  MarkerOptions({
    this.snippet = "",
    required this.position,
    this.title = "",
    required this.params,
    this.isDraggable = true,
    this.id = '',
    this.iconPath = '',
    this.isFile = false,
    this.width = 0,
    this.height = 0,
  });

  factory MarkerOptions.fromJson(Map<String, dynamic> json) {
    // final latitude = double.tryParse(json['latitude'].toString()) ?? 0;
    // final longitude = double.tryParse(json['longitude'].toString()) ?? 0;
    Map latJson = json['position'];
    Map params = json.containsKey('params') ? json['params'] : {};
    return MarkerOptions(
      snippet: json.containsKey('snippet') ? json['snippet'] : '',
      title: json.containsKey('title') ? json['title'] : '',
      width: json.containsKey('width') ? json['width'] : 0,
      height: json.containsKey('height') ? json['height'] : 0,
      position: LatLng.fromJson(latJson.cast()),
      params: params.cast(),
      isDraggable: json.containsKey("draggable") ? json['draggable'] : true,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     "snippet": snippet,
  //     "title": title,
  //     "params": params,
  //     "isDraggable": isDraggable,
  //     "position": position.toJson(),
  //   };
  // }

  Map<String, dynamic> toParams() {
    return {
      "snippet": snippet,
      "draggable": isDraggable,
      "title": title,
      "params": params,
      "position": position.toJson(),
      "id": id,
      "iconPath": iconPath,
      "isFile": isFile,
      "width": width,
      "height": height,
    };
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
