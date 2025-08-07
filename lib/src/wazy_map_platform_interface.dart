import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:wazy_map/library.dart';

import 'map_type.dart';
import 'wazy_map_method_channel.dart';

abstract class WazyMapPlatform extends PlatformInterface {
  /// Constructs a WazyMapPlatform.
  WazyMapPlatform() : super(token: _token);

  static final Object _token = Object();

  static WazyMapPlatform _instance = MethodChannelWazyMap();

  /// The default instance of [WazyMapPlatform] to use.
  ///
  /// Defaults to [MethodChannelWazyMap].
  static WazyMapPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WazyMapPlatform] when
  /// they register themselves.
  static set instance(WazyMapPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  setListener(MapListener? listener) {
    throw UnimplementedError('init() has not been implemented.');
  }

  init() {
    throw UnimplementedError('init() has not been implemented.');
  }

  @visibleForTesting
  onMapReady() {
    throw UnimplementedError('onMapReady() has not been implemented.');
  }

  @visibleForTesting
  onMarkerClick(Marker marker) {
    throw UnimplementedError('onMarkerClick() has not been implemented.');
  }

  @visibleForTesting
  onMarkerDragStart(Marker marker) {
    throw UnimplementedError('onMarkerDragStart() has not been implemented.');
  }

  @visibleForTesting
  onMarkerDrag(Marker marker) {
    throw UnimplementedError('onMarkerDrag() has not been implemented.');
  }

  @visibleForTesting
  onMarkerDragEnd(Marker marker) {
    throw UnimplementedError('onMarkerDragEnd() has not been implemented.');
  }

  @visibleForTesting
  onMapLongClick(LatLng latlng) {
    throw UnimplementedError('onMapLongClick() has not been implemented.');
  }

  @visibleForTesting
  onCameraMoveCancel() {
    throw UnimplementedError('onCameraMoveCancel() has not been implemented.');
  }

  @visibleForTesting
  onCameraMove(LatLng? centerPosition) {
    throw UnimplementedError('onCameraMove() has not been implemented.');
  }

  @visibleForTesting
  onCameraMoveStart(int index) {
    throw UnimplementedError('onCameraMoveStart() has not been implemented.');
  }

  @visibleForTesting
  onFling() {
    throw UnimplementedError('onFling() has not been implemented.');
  }

  @visibleForTesting
  onMove() {
    throw UnimplementedError('onMove() has not been implemented.');
  }

  @visibleForTesting
  onMoveBegin() {
    throw UnimplementedError('onMoveBegin() has not been implemented.');
  }

  @visibleForTesting
  onMoveEnd(LatLng? centerPosition) {
    throw UnimplementedError('onMoveEnd() has not been implemented.');
  }

  @visibleForTesting
  onScale(StandardScaleGestureDetector detector) {
    throw UnimplementedError('onScale() has not been implemented.');
  }

  @visibleForTesting
  onScaleBegin(StandardScaleGestureDetector detector) {
    throw UnimplementedError('onScaleBegin() has not been implemented.');
  }

  @visibleForTesting
  onScaleEnd(StandardScaleGestureDetector detector) {
    throw UnimplementedError('onScaleEnd() has not been implemented.');
  }

  onDestroy() {
    throw UnimplementedError('onDestroy() has not been implemented.');
  }

  onStop() {
    throw UnimplementedError('onStop() has not been implemented.');
  }

  onPause() {
    throw UnimplementedError('onPause() has not been implemented.');
  }

  onResume() {
    throw UnimplementedError('onResume() has not been implemented.');
  }

  showLocationView(LatLng latlng) {
    throw UnimplementedError('showLocationView() has not been implemented.');
  }

  setMapType(BaseMapType mapType) {
    throw UnimplementedError('setMapType() has not been implemented.');
  }

  addMarker(MarkerOptions options) {
    throw UnimplementedError('addMarker() has not been implemented.');
  }

  Future<Map<String, Marker>> getMarkers() {
    throw UnimplementedError('getMarkers() has not been implemented.');
  }

  removeMarker(String id) {
    throw UnimplementedError('removeMarker() has not been implemented.');
  }

  removeMarkers([List<String>? ids]) {
    throw UnimplementedError('removeMarker() has not been implemented.');
  }

  addCircle(CircleOptions circleOptions) {
    throw UnimplementedError('addCircle() has not been implemented.');
  }

  Future<Map<String, Circle>> getCircles() {
    throw UnimplementedError('getCircles() has not been implemented.');
  }

  removeCircles([List<String>? ids]) {
    throw UnimplementedError('removeCircles() has not been implemented.');
  }

  removeCircle(String id) {
    throw UnimplementedError('removeCircle() has not been implemented.');
  }

  addPolygon(PolygonOptions polygonOptions) {
    throw UnimplementedError('addPolygon() has not been implemented.');
  }

  Future<Map<String, Polygon>> getPolygons() {
    throw UnimplementedError('getPolygons() has not been implemented.');
  }

  removePolygons([List<String>? ids]) {
    throw UnimplementedError('removePolygons() has not been implemented.');
  }

  removePolygon(String id) {
    throw UnimplementedError('removePolygon() has not been implemented.');
  }

  addPolyline(PolylineOptions polylineOptions) {
    throw UnimplementedError('addPolyline() has not been implemented.');
  }

  Future<Map<String, Polyline>> getPolylines() {
    throw UnimplementedError('getPolylines() has not been implemented.');
  }

  removePolylines([List<String>? ids]) {
    throw UnimplementedError('removePolylines() has not been implemented.');
  }

  removePolyline(String id) {
    throw UnimplementedError('removePolyline() has not been implemented.');
  }

  Future<LatLng?> getCenterLocation() {
    throw UnimplementedError('getCenterLocation() has not been implemented.');
  }
}

mixin MapListener {
  onMapReady();

  onMarkerClick(Marker marker);

  onMarkerDrag(Marker marker);

  onMarkerDragStart(Marker marker);

  onMarkerDragEnd(Marker marker);

  onMapLongClick(LatLng latlng);

  onCameraMoveCancel();

  onCameraMoveStart(int index);

  onCameraMove(LatLng? centerPosition);

  onFling();

  onMove();

  onMoveBegin();

  onMoveEnd(LatLng? centerPosition);

  onScale(StandardScaleGestureDetector detector);

  onScaleBegin(StandardScaleGestureDetector detector);

  onScaleEnd(StandardScaleGestureDetector detector);
}
