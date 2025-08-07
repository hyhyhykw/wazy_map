import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wazy_map/library.dart';

import 'map_type.dart';
import 'wazy_map_platform_interface.dart';

const String pxGameViewType = "jlb_map";

class WazyMapView extends StatefulWidget {
  ///宽
  final double width;

  ///高
  final double height;

  final void Function(WazyMapController controller) onMapCreated;

  const WazyMapView({
    super.key,
    required this.width,
    required this.height,
    required this.onMapCreated,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<WazyMapView> with MapListener {
  @override
  void initState() {
    super.initState();
    WazyMapPlatform.instance.setListener(this);
  }

  WazyMapController? _controller;

  @override
  void dispose() {
    super.dispose();
    WazyMapPlatform.instance.setListener(null);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Platform.isIOS
          ? UiKitView(
              viewType: pxGameViewType,
              layoutDirection: TextDirection.ltr,
              // creationParams: creationParams,
              creationParamsCodec: const StandardMessageCodec(),
            )
          : AndroidView(
              viewType: pxGameViewType,
              layoutDirection: TextDirection.ltr,
              // creationParams: creationParams,
              creationParamsCodec: const StandardMessageCodec(),
            ),
    );
  }

  @override
  onMapReady() {
    _controller = WazyMapController();
    widget.onMapCreated.call(_controller!);
  }

  @override
  onCameraMove(LatLng? centerPosition) {
    _controller?._onCameraMoveListener?.onCameraMove(centerPosition);
  }

  @override
  onCameraMoveCancel() {
    _controller?._onCameraMoveListener?.onCameraMoveCancel();
  }

  @override
  onCameraMoveStart(int index) {
    _controller?._onCameraMoveListener?.onCameraMoveStart(index);
  }

  @override
  onFling() {
    _controller?._onFling?.call();
  }

  @override
  onMapLongClick(LatLng latlng) {
    _controller?._onMapLongClick?.call(latlng);
  }

  @override
  onMarkerClick(Marker marker) {
    _controller?._onMarkerClick?.call(marker);
  }

  @override
  onMarkerDrag(Marker marker) {
    _controller?._onMarkerDragListener?.onMarkerDrag(marker);
  }

  @override
  onMarkerDragEnd(Marker marker) {
    _controller?._onMarkerDragListener?.onMarkerDragEnd(marker);
  }

  @override
  onMarkerDragStart(Marker marker) {
    _controller?._onMarkerDragListener?.onMarkerDragStart(marker);
  }

  @override
  onMove() {
    _controller?._onMoveListener?.onMove();
  }

  @override
  onMoveBegin() {
    _controller?._onMoveListener?.onMoveBegin();
  }

  @override
  onMoveEnd(LatLng? centerPosition) {
    _controller?._onMoveListener?.onMoveEnd(centerPosition);
  }

  @override
  onScale(StandardScaleGestureDetector detector) {
    _controller?._onScaleListener?.onScale(detector);
  }

  @override
  onScaleBegin(StandardScaleGestureDetector detector) {
    _controller?._onScaleListener?.onScaleBegin(detector);
  }

  @override
  onScaleEnd(StandardScaleGestureDetector detector) {
    _controller?._onScaleListener?.onScaleEnd(detector);
  }
}

class WazyMapController {
  OnScaleListener? _onScaleListener;
  OnMoveListener? _onMoveListener;
  OnMarkerDragListener? _onMarkerDragListener;
  OnCameraMoveListener? _onCameraMoveListener;

  VoidCallback? _onFling;
  void Function(Marker marker)? _onMarkerClick;
  void Function(LatLng latlng)? _onMapLongClick;

  setOnScaleListener(OnScaleListener onScaleListener) {
    _onScaleListener = onScaleListener;
  }

  setOnFling(VoidCallback onFling) {
    _onFling = onFling;
  }

  setOnMarkerClick(void Function(Marker marker)? onMarkerClick) {
    _onMarkerClick = onMarkerClick;
  }

  setOnCameraMoveListener(OnCameraMoveListener? onCameraMoveListener) {
    _onCameraMoveListener = onCameraMoveListener;
  }

  setOnMapLongClick(void Function(LatLng latlng)? onMapLongClick) {
    _onMapLongClick = onMapLongClick;
  }

  setOnMoveListener(OnMoveListener onMoveListener) {
    _onMoveListener = onMoveListener;
  }

  setOnMarkerDragListener(OnMarkerDragListener onMarkerDragListener) {
    _onMarkerDragListener = onMarkerDragListener;
  }

  //todo
  onDestroy() {
    WazyMapPlatform.instance.onDestroy();
  }

  onStop() {
    WazyMapPlatform.instance.onStop();
  }

  onPause() {
    WazyMapPlatform.instance.onPause();
  }

  onResume() {
    WazyMapPlatform.instance.onResume();
  }

  showLocationView(LatLng latlng) {
    WazyMapPlatform.instance.showLocationView(latlng);
  }

  setMapType(BaseMapType mapType) {
    WazyMapPlatform.instance.setMapType(mapType);
  }

  removeMarkers([List<String>? ids]) {
    WazyMapPlatform.instance.removeMarkers(ids);
  }

  addMarker(MarkerOptions options) {
    WazyMapPlatform.instance.addMarker(options);
  }

  Future<Map<String, Marker>> getMarkers() {
    return WazyMapPlatform.instance.getMarkers();
  }

  addCircle(CircleOptions circleOptions) {
    WazyMapPlatform.instance.addCircle(circleOptions);
  }

  removeMarker(String id) {
    WazyMapPlatform.instance.removeMarker(id);
  }

  removeCircle(String id) {
    WazyMapPlatform.instance.removeCircle(id);
  }

  Future<Map<String, Circle>> getCircles() {
    return WazyMapPlatform.instance.getCircles();
  }

  removeCircles([List<String>? ids]) {
    WazyMapPlatform.instance.removeCircles(ids);
  }

  addPolygon(PolygonOptions options) {
    WazyMapPlatform.instance.addPolygon(options);
  }

  removePolygon(String id) {
    WazyMapPlatform.instance.removePolygon(id);
  }

  Future<Map<String, Polygon>> getPolygons() {
    return WazyMapPlatform.instance.getPolygons();
  }

  removePolygons([List<String>? ids]) {
    WazyMapPlatform.instance.removePolygons(ids);
  }

  addPolyline(PolylineOptions options) {
    WazyMapPlatform.instance.addPolyline(options);
  }

  removePolyline(String id) {
    WazyMapPlatform.instance.removePolyline(id);
  }

  Future<Map<String, Polyline>> getPolylines() {
    return WazyMapPlatform.instance.getPolylines();
  }

  removePolylines([List<String>? ids]) {
    WazyMapPlatform.instance.removePolylines(ids);
  }

  Future<LatLng?> getCenterLocation() {
    return WazyMapPlatform.instance.getCenterLocation();
  }
}
