import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:wazy_map/src/latlng.dart';

import 'circle.dart';
import 'detector.dart';
import 'map_type.dart';
import 'marker.dart';
import 'polygon.dart';
import 'polyline.dart';
import 'wazy_map_platform_interface.dart';

/// An implementation of [WazyMapPlatform] that uses method channels.
class MethodChannelWazyMap extends WazyMapPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('wazy_map');
  MapListener? _mapListener;
  static const _onMapReady = "onMapReady";
  static const _onMarkerClick = "onMarkerClick";

  static const _onMarkerDragStart = "onMarkerDragStart";
  static const _onMarkerDrag = "onMarkerDrag";
  static const _onMarkerDragEnd = "onMarkerDragEnd";

  static const _onMapLongClick = "onMapLongClick";

  static const _onCameraMoveCancel = "onCameraMoveCancel";
  static const _onCameraMove = "onCameraMove";
  static const _onCameraMoveStart = "onCameraMoveStart";

  static const _onFling = "onFling";

  static const _onMove = "onMove";
  static const _onMoveBegin = "onMoveBegin";
  static const _onMoveEnd = "onMoveEnd";

  static const _onScale = "onScale";
  static const _onScaleBegin = "onScaleBegin";
  static const _onScaleEnd = "onScaleEnd";

  @override
  setListener(MapListener? listener) {
    _mapListener = listener;
  }

  @override
  init() {
    methodChannel.setMethodCallHandler((methodCall) async {
      final method = methodCall.method;
      final arguments = methodCall.arguments;

      switch (method) {
        case _onMapReady:
          onMapReady();
          break;
        case _onMarkerClick:
          if (arguments is Map) {
            onMarkerClick(Marker.fromJson(arguments.cast()));
          }

          break;
        case _onMarkerDragStart:
          if (arguments is Map) {
            onMarkerDragStart(Marker.fromJson(arguments.cast()));
          }
          break;
        case _onMarkerDrag:
          if (arguments is Map) {
            onMarkerDrag(Marker.fromJson(arguments.cast()));
          }
          break;
        case _onMarkerDragEnd:
          if (arguments is Map) {
            onMarkerDragEnd(Marker.fromJson(arguments.cast()));
          }
          break;
        case _onMapLongClick:
          if (arguments is Map) {
            onMapLongClick(LatLng.fromJson(arguments.cast()));
          }
          break;
        case _onCameraMoveCancel:
          onCameraMoveCancel();
          break;
        case _onCameraMove:
          onCameraMove(
              arguments is! Map ? null : LatLng.fromJson(arguments.cast()));
          break;
        case _onCameraMoveStart:
          final index = arguments['index'];
          onCameraMoveStart(int.tryParse(index.toString()) ?? 0);
          break;
        case _onFling:
          onFling();
          break;
        case _onMove:
          onMove();
          break;
        case _onMoveEnd:
          onMoveEnd(
              arguments is! Map ? null : LatLng.fromJson(arguments.cast()));
          break;
        case _onMoveBegin:
          onMoveBegin();
          break;
        case _onScale:
          if (arguments is Map) {
            onScale(StandardScaleGestureDetector.fromJson(arguments.cast()));
          }
          break;
        case _onScaleBegin:
          if (arguments is Map) {
            onScaleBegin(
                StandardScaleGestureDetector.fromJson(arguments.cast()));
          }
          break;
        case _onScaleEnd:
          if (arguments is Map) {
            onScaleEnd(StandardScaleGestureDetector.fromJson(arguments.cast()));
          }
          break;
      }
    });
  }

  @visibleForTesting
  @override
  onMarkerClick(Marker marker) {
    _mapListener?.onMarkerClick(marker);
  }

  @visibleForTesting
  @override
  onMapReady() {
    _mapListener?.onMapReady();
  }

  @visibleForTesting
  @override
  onMarkerDrag(Marker marker) {
    _mapListener?.onMarkerDrag(marker);
  }

  @visibleForTesting
  @override
  onMarkerDragEnd(Marker marker) {
    _mapListener?.onMarkerDragEnd(marker);
  }

  @visibleForTesting
  @override
  onMarkerDragStart(Marker marker) {
    _mapListener?.onMarkerDragEnd(marker);
  }

  @visibleForTesting
  @override
  onMapLongClick(LatLng latlng) {
    _mapListener?.onMapLongClick(latlng);
  }

  @visibleForTesting
  @override
  onCameraMoveCancel() {
    _mapListener?.onCameraMoveCancel();
  }

  @visibleForTesting
  @override
  onCameraMove(LatLng? centerPosition) {
    _mapListener?.onCameraMove(centerPosition);
  }

  @visibleForTesting
  @override
  onCameraMoveStart(int index) {
    _mapListener?.onCameraMoveStart(index);
  }

  @visibleForTesting
  @override
  onFling() {
    _mapListener?.onFling();
  }

  @visibleForTesting
  @override
  onMove() {
    _mapListener?.onMove();
  }

  @visibleForTesting
  @override
  onMoveBegin() {
    _mapListener?.onMoveBegin();
  }

  @visibleForTesting
  @override
  onMoveEnd(LatLng? centerPosition) {
    _mapListener?.onMoveEnd(centerPosition);
  }

  @visibleForTesting
  @override
  onScale(StandardScaleGestureDetector detector) {
    _mapListener?.onScale(detector);
  }

  @visibleForTesting
  @override
  onScaleBegin(StandardScaleGestureDetector detector) {
    _mapListener?.onScaleBegin(detector);
  }

  @visibleForTesting
  @override
  onScaleEnd(StandardScaleGestureDetector detector) {
    _mapListener?.onScaleEnd(detector);
  }

  static const _onDestroy = "onDestroy";
  static const _onStop = "onStop";
  static const _onPause = "onPause";
  static const _onResume = "onResume";

  static const _showLocationView = "showLocationView";
  static const _setMapType = "setMapType";

  static const _addMarker = "addMarker";
  static const _getMarkers = "getMarkers";
  static const _removeMarker = "removeMarker";
  static const _removeMarkers = "removeMarkers";

  static const _addCircle = "addCircle";
  static const _removeCircle = "removeCircle";
  static const _getCircles = "getCircles";
  static const _removeCircles = "removeCircles";

  static const _addPolygon = "addPolygon";
  static const _removePolygon = "remove Polygon";
  static const _getPolygons = "get Polygons";
  static const _removePolygons = "remove Polygons";

  static const _addPolyline = "addPolyline";
  static const _removePolyline = "removePolyline";
  static const _getPolylines = "getPolylines";
  static const _removePolylines = "removePolylines";

  static const _getCenterLocation = "getCenterLocation";

  @override
  onDestroy() {
    methodChannel.invokeMethod(_onDestroy);
  }

  @override
  onStop() {
    methodChannel.invokeMethod(_onStop);
  }

  @override
  onPause() {
    methodChannel.invokeMethod(_onPause);
  }

  @override
  onResume() {
    methodChannel.invokeMethod(_onResume);
  }

  @override
  showLocationView(LatLng latlng) {
    methodChannel.invokeMethod(_showLocationView, latlng.toJson());
  }

  //AndroidMapType
  //IOSMapType
  @override
  setMapType(BaseMapType mapType) {
    if (Platform.isIOS && mapType is! IOSMapType) {
      throw UnsupportedError(
          "only support:'standard', 'satellite', 'hybrid', 'satelliteFlyover', 'hybridFlyover', 'mutedStandard' for IOS device");
    }

    if (Platform.isAndroid && mapType is! AndroidMapType) {
      throw UnsupportedError(
          "only support:'default\$', 'lightBlue', 'grayWhite', 'darkBlue' for Android device");
    }

    methodChannel.invokeMethod(_setMapType, mapType.type);
  }

  @override
  addMarker(MarkerOptions options) {
    if (options.id.isEmpty || options.iconPath.isEmpty) {
      throw UnsupportedError("property 'id' and 'iconPath' cant be empty");
    }
    if (Platform.isIOS) {
      if (options.width <= 0 || options.height <= 0) {
        throw UnsupportedError(
            "on ios, property 'width' and 'height' cant be negative");
      }
    }
    methodChannel.invokeMethod(_addMarker, options.toParams());
  }

  @override
  Future<Map<String, Marker>> getMarkers() async {
    final result = await methodChannel.invokeMethod(_getMarkers);
    if (result is! Map) {
      return {};
    }
    final markers = <String, Marker>{};
    result.forEach((key, value) {
      if (value is! Map) return;
      markers[key.toString()] = Marker.fromJson(value.cast());
    });
    return markers;
  }

  @override
  removeMarker(String id) {
    methodChannel.invokeMethod(_removeMarker, id);
  }

  @override
  removeMarkers([List<String>? ids]) {
    if (ids == null || ids.isEmpty) {
      methodChannel.invokeMethod(_removeMarkers);
      return;
    }
    final arguments = <String, dynamic>{'ids': ids};
    methodChannel.invokeMethod(_removeMarkers, arguments);
  }

  @override
  addCircle(CircleOptions circleOptions) {
    methodChannel.invokeMethod(_addCircle, circleOptions.toParams());
  }

  @override
  Future<Map<String, Circle>> getCircles() async {
    final result = await methodChannel.invokeMethod(_getCircles);
    if (result is! Map) {
      return {};
    }
    final circles = <String, Circle>{};
    result.forEach((key, value) {
      if (value is! Map) return;
      circles[key.toString()] = Circle.fromJson(value.cast());
    });
    return circles;
  }

  @override
  removeCircle(String id) {
    methodChannel.invokeMethod(_removeCircle, id);
  }

  @override
  removeCircles([List<String>? ids]) {
    if (ids == null || ids.isEmpty) {
      methodChannel.invokeMethod(_removeCircles);
      return;
    }
    final arguments = <String, dynamic>{'ids': ids};
    methodChannel.invokeMethod(_removeCircles, arguments);
  }

  @override
  addPolygon(PolygonOptions polygonOptions) {
    methodChannel.invokeMethod(_addPolygon, polygonOptions.toParams());
  }

  @override
  Future<Map<String, Polygon>> getPolygons() async {
    final result = await methodChannel.invokeMethod(_getPolygons);
    if (result is! Map) {
      return {};
    }
    final polygons = <String, Polygon>{};
    result.forEach((key, value) {
      if (value is! Map) return;
      polygons[key.toString()] = Polygon.fromJson(value.cast());
    });
    return polygons;
  }

  @override
  removePolygons([List<String>? ids]) {
    if (ids == null || ids.isEmpty) {
      methodChannel.invokeMethod(_removePolygons);
      return;
    }
    final arguments = <String, dynamic>{'ids': ids};
    methodChannel.invokeMethod(_removePolygons, arguments);
  }

  @override
  removePolygon(String id) {
    methodChannel.invokeMethod(_removePolygon, id);
  }

  @override
  addPolyline(PolylineOptions polylineOptions) {
    methodChannel.invokeMethod(_addPolyline, polylineOptions.toParams());
  }

  @override
  Future<Map<String, Polyline>> getPolylines() async {
    final result = await methodChannel.invokeMethod(_getPolylines);
    if (result is! Map) {
      return {};
    }
    final polylines = <String, Polyline>{};
    result.forEach((key, value) {
      if (value is! Map) return;
      polylines[key.toString()] = Polyline.fromJson(value.cast());
    });
    return polylines;
  }

  @override
  removePolylines([List<String>? ids]) {
    if (ids == null || ids.isEmpty) {
      methodChannel.invokeMethod(_removePolylines);
      return;
    }
    final arguments = <String, dynamic>{'ids': ids};
    methodChannel.invokeMethod(_removePolylines, arguments);
  }

  @override
  removePolyline(String id) {
    methodChannel.invokeMethod(_removePolyline, id);
  }

  @override
  Future<LatLng?> getCenterLocation() async {
    final json = await methodChannel.invokeMethod(_getCenterLocation);
    if (json is! Map) return null;
    return LatLng.fromJson(json.cast());
  }
}
