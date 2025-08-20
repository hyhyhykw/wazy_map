package com.jlb.map;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.util.Log;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.target.CustomViewTarget;
import com.bumptech.glide.request.transition.Transition;
import com.mapbox.android.gestures.MoveGestureDetector;
import com.mapbox.android.gestures.StandardScaleGestureDetector;
import com.wz.location.map.Map;
import com.wz.location.map.common.MapType;
import com.wz.location.map.model.Circle;
import com.wz.location.map.model.CircleOptions;
import com.wz.location.map.model.LatLng;
import com.wz.location.map.model.Marker;
import com.wz.location.map.model.MarkerOptions;
import com.wz.location.map.model.Polygon;
import com.wz.location.map.model.PolygonOptions;
import com.wz.location.map.model.Polyline;
import com.wz.location.map.model.PolylineOptions;
import com.wz.location.map.view.WZMap;

import java.io.File;
import java.util.HashMap;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

/**
 *
 */
public class WazyMap implements PlatformView, MethodChannel.MethodCallHandler {
    final Context mContext;
    final int viewId;
    private final MethodChannel channel;
    private final WZMap mWZMap;
    private final FlutterPlugin.FlutterAssets flutterAssets;

    public WazyMap(Context context, int viewId, MethodChannel channel, FlutterPlugin.FlutterAssets flutterAssets) {
        mContext = context;
        this.viewId = viewId;
        this.channel = channel;
        this.flutterAssets = flutterAssets;
        channel.setMethodCallHandler(this);
        mWZMap = new WZMap(context);
        initMap();
    }


    private static final String METHOD_ON_MAP_READY = "onMapReady";
    private static final String METHOD_ON_MARKER_CLICK = "onMarkerClick";

    private static final String METHOD_ON_MARKER_DRAG_START = "onMarkerDragStart";
    private static final String METHOD_ON_MARKER_DRAG = "onMarkerDrag";
    private static final String METHOD_ON_MARKER_DRAG_END = "onMarkerDragEnd";


    private static final String METHOD_ON_MAP_LONG_CLICK = "onMapLongClick";


    private static final String METHOD_ON_CAMERA_MOVE_CANCEL = "onCameraMoveCancel";
    private static final String METHOD_ON_CAMERA_MOVE = "onCameraMove";
    private static final String METHOD_ON_CAMERA_MOVE_START = "onCameraMoveStart";


    private static final String METHOD_ON_FLING = "onFling";

    private static final String METHOD_ON_MOVE = "onMove";
    private static final String METHOD_ON_MOVE_START = "onMoveBegin";
    private static final String METHOD_ON_MOVE_END = "onMoveEnd";

    private static final String METHOD_ON_SCALE = "onScale";
    private static final String METHOD_ON_SCALE_BEGIN = "onScaleBegin";
    private static final String METHOD_ON_SCALE_END = "onScaleEnd";

    private void initMap() {
        mWZMap.onCreate(null);
        mWZMap.setMapReadyListener(() -> channel.invokeMethod(METHOD_ON_MAP_READY, null));
        mWZMap.setOnMarkerClickListener(marker -> {
//            String markerId = marker.getId();
//            if(BuildConfig.DEBUG){
//                Log.e("TAG","markerId========>"+markerId);
//            }
//            Marker fullMarker = mMarkers.get(markerId);
//            if (fullMarker == null) return false;

            if(BuildConfig.DEBUG){
                Log.e("TAG","markerId222222222========>"+marker.getId());
            }

            channel.invokeMethod(METHOD_ON_MARKER_CLICK, marker.toArguments());
            return true;
        });
        mWZMap.setOnMarkerDragListener(new Map.OnMarkerDragListener() {
            @Override
            public void onMarkerDragStart(Marker marker) {
                String markerId = marker.getId();

                Marker fullMarker = mWZMap.getMarker(markerId);
                if (fullMarker == null) return;
                channel.invokeMethod(METHOD_ON_MARKER_DRAG_START, fullMarker.toArguments());
            }

            @Override
            public void onMarkerDrag(Marker marker) {
                String markerId = marker.getId();
                Marker fullMarker = mWZMap.getMarker(markerId);
                if (fullMarker == null) return;
                channel.invokeMethod(METHOD_ON_MARKER_DRAG, fullMarker.toArguments());
            }

            @Override
            public void onMarkerDragEnd(Marker marker) {
                String markerId = marker.getId();
                Marker fullMarker = mWZMap.getMarker(markerId);
                if (fullMarker == null) return;
                channel.invokeMethod(METHOD_ON_MARKER_DRAG_END, fullMarker.toArguments());
            }
        });
        mWZMap.addOnMapLongClickListener(latLng -> channel.invokeMethod(METHOD_ON_MAP_LONG_CLICK, latLng.toArguments()));
        mWZMap.addOnCameraMoveCancelListener(() -> channel.invokeMethod(METHOD_ON_CAMERA_MOVE_CANCEL, null));
        mWZMap.addOnCameraMoveListener(() -> {
            LatLng location = mWZMap.getCenterLocation();
            channel.invokeMethod(METHOD_ON_CAMERA_MOVE, location == null ? null : location.toArguments());
        });
        mWZMap.addOnCameraMoveStartedListener(index -> {
            HashMap<String, Object> map = new HashMap<>();
            map.put("index", index);
            channel.invokeMethod(METHOD_ON_CAMERA_MOVE_START, map);
        });
        mWZMap.onAddFlingListener(() -> channel.invokeMethod(METHOD_ON_FLING, null));
        mWZMap.addOnMoveListener(new Map.OnMoveListener() {
            @Override
            public void onMoveBegin(@NonNull MoveGestureDetector var1) {
                channel.invokeMethod(METHOD_ON_MOVE_START, null);
            }

            @Override
            public void onMove(@NonNull MoveGestureDetector var1) {
                channel.invokeMethod(METHOD_ON_MOVE, null);
            }

            @Override
            public void onMoveEnd(@NonNull MoveGestureDetector var1) {
                LatLng location = mWZMap.getCenterLocation();
                channel.invokeMethod(METHOD_ON_MOVE_END, location == null ? null : location.toArguments());
            }
        });
        mWZMap.onAddScaleListener(new Map.OnScaleListener() {
            @Override
            public void onScaleBegin(@NonNull StandardScaleGestureDetector detector) {
                channel.invokeMethod(METHOD_ON_SCALE_BEGIN, detector2Map(detector));
            }

            @Override
            public void onScale(@NonNull StandardScaleGestureDetector detector) {
                channel.invokeMethod(METHOD_ON_SCALE, detector2Map(detector));
            }

            @Override
            public void onScaleEnd(@NonNull StandardScaleGestureDetector detector) {
                channel.invokeMethod(METHOD_ON_SCALE_END, detector2Map(detector));
            }
        });
    }

    @NonNull
    private HashMap<String, Object> detector2Map(@NonNull StandardScaleGestureDetector detector) {
        HashMap<String, Object> arguments = new HashMap<>();
        double currentSpan = detector.getCurrentSpan();
        double currentSpanX = detector.getCurrentSpanX();
        double currentSpanY = detector.getCurrentSpanY();
        double previousSpan = detector.getPreviousSpan();
        double previousSpanX = detector.getPreviousSpanX();
        double previousSpanY = detector.getPreviousSpanY();
        double startSpan = detector.getStartSpan();
        double startSpanX = detector.getStartSpanX();
        double startSpanY = detector.getStartSpanY();

        arguments.put("currentSpan", currentSpan);
        arguments.put("currentSpanX", currentSpanX);
        arguments.put("currentSpanY", currentSpanY);
        arguments.put("previousSpan", previousSpan);
        arguments.put("previousSpanX", previousSpanX);
        arguments.put("previousSpanY", previousSpanY);
        arguments.put("startSpan", startSpan);
        arguments.put("startSpanX", startSpanX);
        arguments.put("startSpanY", startSpanY);

        return arguments;
    }


    @Nullable
    @Override
    public View getView() {
        return mWZMap;
    }

    @Override
    public void dispose() {
        mWZMap.onDestroy();
    }


    private static final String METHOD_ON_DESTROY = "onDestroy";
    private static final String METHOD_ON_STOP = "onStop";
    private static final String METHOD_ON_PAUSE = "onPause";
    private static final String METHOD_ON_RESUME = "onResume";

    private static final String METHOD_SHOW_LOCATION_VIEW = "showLocationView";
    private static final String METHOD_SET_MAP_TYPE = "setMapType";

    private static final String METHOD_ADD_MARKER = "addMarker";
    private static final String METHOD_GET_MARKERS = "getMarkers";
    private static final String METHOD_REMOVE_MARKER = "removeMarker";
    private static final String METHOD_REMOVE_MARKERS = "removeMarkers";

    private static final String METHOD_ADD_CIRCLE = "addCircle";
    private static final String METHOD_GET_CIRCLES = "getCircles";
    private static final String METHOD_REMOVE_CIRCLE = "removeCircle";
    private static final String METHOD_REMOVE_CIRCLES = "removeCircles";

    private static final String METHOD_ADD_POLYLINE = "addPolyline";
    private static final String METHOD_GET_POLYLINES = "getPolylines";
    private static final String METHOD_REMOVE_POLYLINE = "removePolyline";
    private static final String METHOD_REMOVE_POLYLINES = "removePolylines";

    private static final String METHOD_ADD_POLYGON = "addPolygon";
    private static final String METHOD_GET_POLYGONS = "getPolygons";
    private static final String METHOD_REMOVE_POLYGON = "removePolygon";
    private static final String METHOD_REMOVE_POLYGONS = "removePolygons";

    private static final String METHOD_GET_CURRENT_LOCATION = "getCenterLocation";


    final HashMap<String, Circle> mCircles = new HashMap<>();

    final HashMap<String, Polyline> mPolylines = new HashMap<>();
    final HashMap<String, Polygon> mPolygons = new HashMap<>();

    /**
     * @noinspection DataFlowIssue
     */
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        String method = call.method;
        switch (method) {
            case METHOD_ON_DESTROY -> mWZMap.onDestroy();
            case METHOD_ON_STOP -> mWZMap.onStop();
            case METHOD_ON_PAUSE -> mWZMap.onPause();
            case METHOD_ON_RESUME -> mWZMap.onResume();
            case METHOD_SHOW_LOCATION_VIEW -> {
                double latitude = call.argument("latitude");
                double longitude = call.argument("longitude");
                mWZMap.showLocationView(longitude, latitude, 0);
            }
            case METHOD_SET_MAP_TYPE -> {
                String arguments = call.arguments.toString();
                MapType mapType = MapType.valueOf(arguments);
                mWZMap.setMapType(mapType);
            }
            case METHOD_GET_CURRENT_LOCATION -> {
                LatLng location = mWZMap.getCenterLocation();
                if (location != null) {
                    result.success(location.toArguments());
                } else {
                    result.error("-1", "Get location failed", "");
                }
            }

            //标记相关
            case METHOD_ADD_MARKER -> {
                final String title = !call.hasArgument("title") ? null : call.argument("title");
                final String snippet = !call.hasArgument("snippet") ? null : call.argument("snippet");
                final boolean draggable = !call.hasArgument("draggable") || call.<Boolean>argument("draggable");
                final boolean isFile = call.hasArgument("isFile") && call.<Boolean>argument("isFile");
                final java.util.Map<String, Object> params = !call.hasArgument("params") ? null : call.argument("params");
                final String id = call.argument("id");
                final String iconPath = call.argument("iconPath");

                if(BuildConfig.DEBUG){
                    android.util.Log.e("TAG","draggable=========>"+draggable);
                }

                final java.util.Map<String, Object> positionJson = call.argument("position");
                final double latitude = (double) positionJson.get("latitude");
                final double longitude = (double) positionJson.get("longitude");

                final Object imageModel;
                if (isFile) {
                    imageModel = new File(iconPath);
                } else {
                    String assetFilePath = flutterAssets.getAssetFilePathByName(iconPath);
                    imageModel = "file:///android_asset/" + assetFilePath;
                }
                Glide.with(mWZMap)
                        .asBitmap()
                        .load(imageModel)
                        .into(new CustomViewTarget<WZMap, Bitmap>(mWZMap) {
                            @Override
                            public void onLoadFailed(@Nullable Drawable errorDrawable) {

                            }

                            @Override
                            public void onResourceReady(@NonNull Bitmap resource, @Nullable Transition<? super Bitmap> transition) {

                                MarkerOptions options = new MarkerOptions()
                                        .title(title)
                                        .snippet(snippet)
                                        .draggable(draggable)
                                        .icon(resource)
                                        .params(params)
                                        .position(
                                                new LatLng(latitude, longitude)
                                        );
                                Marker marker =
                                        getView().addMarker(options, id);
//                                mMarkers.put(id, marker);
                            }

                            @Override
                            protected void onResourceCleared(@Nullable Drawable placeholder) {

                            }
                        });

            }
            case METHOD_REMOVE_MARKER -> {
                String id = call.arguments.toString();

                Marker marker = mWZMap.getMarker(id);
                if (marker != null) {
                    marker.remove();
//                    mMarkers.remove(id);
                }
            }
            case METHOD_REMOVE_MARKERS -> {
                List<String> ids = call.hasArgument("ids") ? call.argument("ids") : null;
                if (ids == null || ids.isEmpty()) {
                    mWZMap.removeAllMarkers();
//                    for (Marker marker : mMarkers.values()) {
//                        marker.remove();
//                    }
//                    mMarkers.clear();
                } else {
                    for (String id : ids) {
                        Marker marker =  mWZMap.getMarker(id);
//                         mMarkers.get(id);
                        if (marker != null) {
                            marker.remove();
//                            mMarkers.remove(id);
                        }
                    }
                }

            }
            case METHOD_GET_MARKERS -> {
                HashMap<String, HashMap<String, Object>> markers = new HashMap<>();
                for (java.util.Map.Entry<String, Marker> entry : mWZMap.getMarkers().entrySet()) {
                    markers.put(entry.getKey(), entry.getValue().toArguments());
                }
                result.success(markers);
            }

            //圆形区域
            case METHOD_ADD_CIRCLE -> {
                double radius = !call.hasArgument("radius") ? 10f : call.argument("radius");
                String fillColor = !call.hasArgument("fillColor") ? null : call.argument("fillColor");
                String strokeColor = !call.hasArgument("strokeColor") ? null : call.argument("strokeColor");
                double strokeWidth = !call.hasArgument("strokeWidth") ? 1f : call.argument("strokeWidth");
                double zIndex = !call.hasArgument("zIndex") ? 0f : call.argument("zIndex");
                boolean isVisible = !call.hasArgument("isVisible") || call.<Boolean>argument("isVisible");
                boolean isDottedLine = call.hasArgument("isDottedLine") && call.<Boolean>argument("isDottedLine");

                String id = call.argument("id");

                final java.util.Map<String, Object> centerJson = call.argument("center");

                final double latitude = (double) centerJson.get("latitude");
                final double longitude = (double) centerJson.get("longitude");

                CircleOptions circleOptions = new CircleOptions()
                        .radius((float) radius)
                        .fillColor(fillColor == null ? Color.TRANSPARENT : Color.parseColor(fillColor))
                        .strokeColor(strokeColor == null ? Color.BLACK : Color.parseColor(strokeColor))
                        .strokeWidth((float) strokeWidth)
                        .visible(isVisible)
                        .zIndex((float) zIndex)
                        .setDottedLine(isDottedLine)
                        .center(new LatLng(latitude, longitude)
                        );

                Circle circle = mWZMap.addCircle(circleOptions, id);
                mCircles.put(id, circle);

            }
            case METHOD_REMOVE_CIRCLE ->  {
                String id = call.arguments.toString();
                Circle circle = mCircles.get(id);
                if (circle != null) {
                    circle.remove();
                    mCircles.remove(id);
                }
            }
            case METHOD_REMOVE_CIRCLES -> {
                List<String> ids = call.hasArgument("ids") ? call.argument("ids") : null;
                if (ids == null || ids.isEmpty()) {
                    for (Circle circle : mCircles.values()) {
                        circle.remove();
                    }
                    mCircles.clear();
                } else {
                    for (String id : ids) {
                        Circle circle = mCircles.get(id);
                        if (circle != null) {
                            circle.remove();
                            mCircles.remove(id);
                        }
                    }
                }

            }
            case METHOD_GET_CIRCLES -> {
                HashMap<String, HashMap<String, Object>> markers = new HashMap<>();
                for (java.util.Map.Entry<String, Circle> entry : mCircles.entrySet()) {
                    markers.put(entry.getKey(), entry.getValue().toArguments());
                }
                result.success(markers);
            }

            //多边形区域
            case METHOD_ADD_POLYGON -> {
                String fillColor = !call.hasArgument("fillColor") ? null : call.argument("fillColor");
                String strokeColor = !call.hasArgument("strokeColor") ? null : call.argument("strokeColor");
                double strokeWidth = !call.hasArgument("strokeWidth") ? 10f : call.argument("strokeWidth");
                double zIndex = !call.hasArgument("zIndex") ? 0f : call.argument("zIndex");
                boolean isVisible = !call.hasArgument("isVisible") || call.<Boolean>argument("isVisible");
                boolean isDottedLine = call.hasArgument("isDottedLine") && call.<Boolean>argument("isDottedLine");
                String id = call.argument("id");

                List<java.util.Map<String, Object>> pointJsons = call.argument("points");
                PolygonOptions polygonOptions = new PolygonOptions()
                        .fillColor(fillColor == null ? Color.TRANSPARENT : Color.parseColor(fillColor))
                        .strokeColor(strokeColor == null ? Color.BLACK : Color.parseColor(strokeColor))
                        .strokeWidth((float) strokeWidth)
                        .visible(isVisible)
                        .zIndex((float) zIndex)
                        .setDottedLine(isDottedLine);
                for (java.util.Map<String, Object> point : pointJsons) {
                    final double latitude = (double) point.get("latitude");
                    final double longitude = (double) point.get("longitude");
                    LatLng latLng = new LatLng(latitude, longitude);
                    polygonOptions.add(latLng);
                }

                Polygon polygon = mWZMap.addPolygon(polygonOptions, id);

                mPolygons.put(id, polygon);

            }
            case METHOD_REMOVE_POLYGON -> {
                String id = call.arguments.toString();
                Polygon polygon = mPolygons.get(id);
                if (polygon != null) {
                    polygon.remove();
                    mPolygons.remove(id);
                }
            }
            case METHOD_GET_POLYGONS -> {
                HashMap<String, HashMap<String, Object>> markers = new HashMap<>();
                for (java.util.Map.Entry<String, Polygon> entry : mPolygons.entrySet()) {
                    markers.put(entry.getKey(), entry.getValue().toArguments());
                }
                result.success(markers);
            }
            case METHOD_REMOVE_POLYGONS -> {
                List<String> ids = call.hasArgument("ids") ? call.argument("ids") : null;
                if (ids == null || ids.isEmpty()) {
                    for (Polygon polygon : mPolygons.values()) {
                        polygon.remove();
                    }
                    mPolygons.clear();
                } else {
                    for (String id : ids) {
                        Polygon polygon = mPolygons.get(id);
                        if (polygon != null) {
                            polygon.remove();
                            mPolygons.remove(id);
                        }
                    }
                }

            }

            //线
            case METHOD_ADD_POLYLINE -> {
                String color = !call.hasArgument("color") ? null : call.argument("color");
                double width = !call.hasArgument("width") ? 10f : call.argument("width");
                double zIndex = !call.hasArgument("zIndex") ? 0f : call.argument("zIndex");
                boolean isVisible = !call.hasArgument("isVisible") || call.<Boolean>argument("isVisible");
                boolean isDottedLine = call.hasArgument("isDottedLine") && call.<Boolean>argument("isDottedLine");
                String id = call.argument("id");

                List<java.util.Map<String, Object>> pointJsons = call.argument("points");
                PolylineOptions polygonOptions = new PolylineOptions()
                        .color(color == null ? Color.TRANSPARENT : Color.parseColor(color))
                        .width((float) width)
                        .visible(isVisible)
                        .zIndex((float) zIndex)
                        .setDottedLine(isDottedLine);

                for (java.util.Map<String, Object> point : pointJsons) {
                    final double latitude = (double) point.get("latitude");
                    final double longitude = (double) point.get("longitude");
                    LatLng latLng = new LatLng(latitude, longitude);
                    polygonOptions.add(latLng);
                }

                Polyline polyline = mWZMap.addPolyline(polygonOptions, id);

                mPolylines.put(id, polyline);

            }
            case METHOD_REMOVE_POLYLINE -> {
                String id = call.arguments.toString();
                Polyline polyline = mPolylines.get(id);
                if (polyline != null) {
                    polyline.remove();
                    mPolylines.remove(id);
                }
            }
            case METHOD_GET_POLYLINES -> {
                HashMap<String, HashMap<String, Object>> markers = new HashMap<>();
                for (java.util.Map.Entry<String, Polyline> entry : mPolylines.entrySet()) {
                    markers.put(entry.getKey(), entry.getValue().toArguments());
                }
                result.success(markers);
            }
            case METHOD_REMOVE_POLYLINES -> {
                List<String> ids = call.hasArgument("ids") ? call.argument("ids") : null;
                if (ids == null || ids.isEmpty()) {
                    for (Polyline polyline : mPolylines.values()) {
                        polyline.remove();
                    }
                    mPolylines.clear();
                } else {
                    for (String id : ids) {
                        Polyline polyline = mPolylines.get(id);
                        if (polyline != null) {
                            polyline.remove();
                            mPolylines.remove(id);
                        }
                    }
                }

            }
        }
    }
}
