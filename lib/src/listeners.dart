import 'detector.dart';
import 'latlng.dart';
import 'marker.dart';

mixin OnScaleListener {
  void onScale(StandardScaleGestureDetector detector) {}

  void onScaleBegin(StandardScaleGestureDetector detector) {}

  void onScaleEnd(StandardScaleGestureDetector detector) {}
}

mixin OnMoveListener {
  void onMoveEnd(LatLng? centerPosition) {}

  void onMove() {}

  void onMoveBegin() {}
}

mixin OnCameraMoveListener {
  void onCameraMove(LatLng? centerPosition) {}

  void onCameraMoveCancel() {}

  void onCameraMoveStart(int index) {}
}

mixin OnMarkerDragListener {
  onMarkerDrag(Marker marker) {}

  onMarkerDragStart(Marker marker) {}

  onMarkerDragEnd(Marker marker) {}
}