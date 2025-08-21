import Flutter
import MapKit

//
//  WazyMapView.swift
//  Pods
//
//  Created by 黄垚 on 2025/8/5.
//

class WazyMapView: NSObject, FlutterPlatformView, MKMapViewDelegate, UIGestureRecognizerDelegate {
    private let frame: CGRect
    private let viewId: Int64
    private let methodChannel: FlutterMethodChannel
    private var mKMapView: MKMapView
    
    init(_ frame: CGRect, viewID: Int64, methodChannel: FlutterMethodChannel) {
        mKMapView = MKMapView(frame: frame)
        self.frame = frame
        self.methodChannel = methodChannel
        viewId = viewID
        super.init()
        methodChannel.setMethodCallHandler(handleMethodCall)
        
        initMap()
    }
    
    private let onMapReady = "onMapReady"
    
    private let onMarkerClick = "onMarkerClick"
    private let onMarkerDragStart = "onMarkerDragStart"
    private let onMarkerDrag = "onMarkerDrag"
    private let onMarkerDragEnd = "onMarkerDragEnd"
    private let onMapLongClick = "onMapLongClick"
    
    private let onCameraMoveCancel = "onCameraMoveCancel"
    private let onCameraMove = "onCameraMove"
    private let onCameraMoveStart = "onCameraMoveStart"
    
    private let onFling = "onFling"
    
    private let onMove = "onMove"
    private let onMoveBegin = "onMoveBegin"
    private let onMoveEnd = "onMoveEnd"
    
    private let onScale = "onScale"
    private let onScaleBegin = "onScaleBegin"
    private let onScaleEnd = "onScaleEnd"

    private func initMap() {
        mKMapView.delegate = self
        // 地图类型设置 - 标准地图
        mKMapView.mapType = .standard
        let location = CLLocationCoordinate2D(latitude: 39.990464, longitude: 116.481488) // 北京的坐标
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // 缩放级别
        let region = MKCoordinateRegion(center: location, span: span)
        mKMapView.setRegion(region, animated: false)
        
        mKMapView.showsUserLocation = false
        
        let lpgr = UILongPressGestureRecognizer(target: self,
                                                action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 1
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        mKMapView.addGestureRecognizer(lpgr)
        
        methodChannel.invokeMethod(onMapReady, arguments: nil)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        print("地图长按")
        
        if gestureRecognizer.state != UIGestureRecognizer.State.ended {
            return
        } else if gestureRecognizer.state != UIGestureRecognizer.State.began {
            let touchPoint = gestureRecognizer.location(in: mKMapView)
            
            let touchMapCoordinate = mKMapView.convert(touchPoint, toCoordinateFrom: mKMapView)
            
            methodChannel.invokeMethod(onMapLongClick, arguments: touchMapCoordinate.toJson())
            
//            yourAnnotation.subtitle = "You long pressed here"
//            yourAnnotation.coordinate = touchMapCoordinate
//            _mapView.addAnnotation(yourAnnotation)
        }
    }
    
    // 标记拖拽
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 didChange newState: MKAnnotationView.DragState,
                 fromOldState oldState: MKAnnotationView.DragState)
    {
        if !(view.annotation is WazyMarker) {
            return
        }
        
        let marker = view.annotation as! WazyMarker
        
        if newState == MKAnnotationView.DragState.starting {
            methodChannel.invokeMethod(onMarkerDragStart, arguments: marker.toJson())
        } else if newState == MKAnnotationView.DragState.dragging {
            methodChannel.invokeMethod(onMarkerDrag, arguments: marker.toJson())
        } else if newState == MKAnnotationView.DragState.ending {
            methodChannel.invokeMethod(onMarkerDragEnd, arguments: marker.toJson())
        }
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        // Your code on rednering completion
//        initMap()
    }
    
    // 地图缩放级别即将发生改变时
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
//            print("地图缩放级别发送改变时")
    }
    
    // mapView显示区域改变时调用 地图缩放完毕触法
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//       label.text = "当前缩放级别：\(mapView.zoomLevel)"
//      slider.value = Float(mapView.zoomLevel)
        let arguments = mKMapView.centerCoordinate.toJson()
        methodChannel.invokeMethod(onCameraMove, arguments: arguments)
    }
    
    // 点击标点
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let marker =  view.annotation as? WazyMarker{
            methodChannel.invokeMethod(onMarkerClick, arguments: marker.toJson())
            mKMapView.deselectAnnotation(view.annotation, animated: false)
        }else{
            print("点击了其他位置")
        }
    }
    
    // 创建标点视图
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is WazyMarker {
            let marker = annotation as! WazyMarker
            let identifier = marker.id
            var markerView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MarkerView
            if markerView == nil {
                markerView = MarkerView(annotation: annotation, reuseIdentifier: identifier)
                markerView?.isDraggable = marker.options.isDraggable
            } else {
                // 重用时更新annotation引用，以防万一。通常不需要，除非你在其他地方做了特殊处理。
                markerView?.annotation = marker
            }
            return markerView
        } else {
            let longitude =  annotation.coordinate.longitude
            let latitude =  annotation.coordinate.latitude
            let identifier = "\(longitude),\(latitude)"
            
            var mKAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if mKAnnotationView == nil {
                mKAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                // 重用时更新annotation引用，以防万一。通常不需要，除非你在其他地方做了特殊处理。
                mKAnnotationView?.annotation = annotation
            }
            return  mKAnnotationView
        }
        
        return nil
    }
    
    // 创建圆形范围视图
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is WazyCircle {
            let wazyCircle = overlay as! WazyCircle
            
            let circleRenderer = MKCircleRenderer(circle: wazyCircle)
            circleRenderer.fillColor = wazyCircle.options.fillColor
            circleRenderer.strokeColor = wazyCircle.options.strokeColor
            circleRenderer.lineWidth = wazyCircle.options.strokeWidth
            
            if wazyCircle.options.isDottedLine {
                circleRenderer.lineDashPattern = [1.0, 2.0] // 虚线长度（2点）
                circleRenderer.lineDashPhase = 0 // 起始偏移量
            }
           
            return circleRenderer
        } else if overlay is WazyPolygon {
            let polygon = overlay as! WazyPolygon
            let polygonRenderer = MKPolygonRenderer(polygon: polygon)
            polygonRenderer.lineWidth = polygon.options.strokeWidth
            polygonRenderer.fillColor = polygon.options.fillColor
            polygonRenderer.strokeColor = polygon.options.strokeColor
            
            if polygon.options.isDottedLine {
                polygonRenderer.lineDashPattern = [1.0, 2.0] // 虚线长度（2点）
                polygonRenderer.lineDashPhase = 0 // 起始偏移量
            }
            
            return polygonRenderer
        } else if overlay is WazyPolyline {
            let polyline = overlay as! WazyPolyline
            let polylineRenderer = MKPolylineRenderer(polyline: polyline)
            
            polylineRenderer.lineWidth = polyline.options.width
            polylineRenderer.strokeColor = polyline.options.color
            
            if polyline.options.isDottedLine {
                polylineRenderer.lineDashPattern = [1.0, 2.0] // 虚线长度（2点）
                polylineRenderer.lineDashPhase = 0 // 起始偏移量
            }
            
            return polylineRenderer
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }

    private let onDestroy = "onDestroy"
    private let onStop = "onStop"
    private let onPause = "onPause"
    private let onResume = "onResume"

    private let showLocationView = "showLocationView"
    private let setMapType = "setMapType"

    private let addMarker = "addMarker"
    private let getMarkers = "getMarkers"
    private let removeMarker = "removeMarker"
    private let removeMarkers = "removeMarkers"

    private let addCircle = "addCircle"
    private let removeCircle = "removeCircle"
    private let getCircles = "getCircles"
    private let removeCircles = "removeCircles"

    private let addPolygon = "addPolygon"
    private let removePolygon = "remove Polygon"
    private let getPolygons = "get Polygons"
    private let removePolygons = "remove Polygons"

    private let addPolyline = "addPolyline"
    private let removePolyline = "removePolyline"
    private let getPolylines = "getPolylines"
    private let removePolylines = "removePolylines"

    private let getCenterLocation = "getCenterLocation"

    public func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method = call.method
        
        print("method======>" + method)
        
        if method == onDestroy {
        } else if method == onStop {
        } else if method == onPause {
        } else if method == onResume {
        } else if method == showLocationView {
            if let arguments = call.arguments as? [String: Any],
               let latitude = arguments["latitude"] as? Double,
               let longitude = arguments["longitude"] as? Double
            {
                // 设置地图区域
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // 缩放级别
                let region = MKCoordinateRegion(center: location, span: span)
                mKMapView.setRegion(region, animated: true)
            }
        } else if method == setMapType {
            if let mapType = call.arguments as? String {
                switch mapType {
                case "standard":
                    mKMapView.mapType = .standard
                case "hybrid":
                    mKMapView.mapType = .hybrid
                case "satellite":
                    mKMapView.mapType = .satellite
                case "satelliteFlyover":
                    mKMapView.mapType = .satelliteFlyover
                case "hybridFlyover":
                    mKMapView.mapType = .hybridFlyover
                case "mutedStandard":
                    mKMapView.mapType = .mutedStandard
                default: print("default case")
                }
            }
            
        } else if method == getCenterLocation {
            let center = mKMapView.centerCoordinate
            result(center.toJson())
        } else if method == addMarker {
            if let arguments = call.arguments as? [String: Any],
               
               let position = arguments["position"] as? [String: Any],
               let latitude = position["latitude"] as? Double,
               let longitude = position["longitude"] as? Double,
               
               let id = arguments["id"] as? String,
               let width = arguments["width"] as? Int,
               let height = arguments["height"] as? Int,
               let iconPath = arguments["iconPath"] as? String,
               let params = arguments["params"] as? [String: Any],
               let isFile = arguments["isFile"] as? Bool,
               let draggable = arguments["draggable"] as? Bool,
               let snippet = arguments["snippet"] as? String,
               let title = arguments["title"] as? String
            {
                
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                // 创建并添加标注
                let options = MarkerOptions(position: coordinate,
                                            title: title,
                                            snippet: snippet,
                                            iconPath: iconPath,
                                            isFile: isFile,
                                            isDraggable: draggable,
                                            params: params,
                                            width: width,
                                            height: height)
                
                let marker = WazyMarker(id: id, coordinate: coordinate, options: options)
                mKMapView.addAnnotation(marker) // 将标注添加到地图上
//                markers[id] = marker
            }
        } else if method == getMarkers {
            var markersJson: [String: Any] = [:]
            for annotation in mKMapView.annotations {
                if annotation is WazyMarker {
                    let marker = annotation as! WazyMarker
                    markersJson[marker.id] = marker.toJson()
                }
            }
           
            result(markersJson)
        } else if method == removeMarker {
            if let identifier = call.arguments as? String {
                let needRemovedMarkers = filterMarkers([identifier])
                if !needRemovedMarkers.isEmpty {
                    mKMapView.removeAnnotations(needRemovedMarkers)
                }
            }
        } else if method == removeMarkers {
            if let arguments = call.arguments as? [String: Any],
               let ids = arguments["ids"] as? [String]
            {
                let needRemovedMarkers = filterMarkers(ids)
                if !needRemovedMarkers.isEmpty {
                    mKMapView.removeAnnotations(needRemovedMarkers)
                }
            } else {
                let needRemovedMarkers = filterMarkers(nil)
                if !needRemovedMarkers.isEmpty {
                    mKMapView.removeAnnotations(needRemovedMarkers)
                }
            }
            
        } else if method == addCircle {
            if let arguments = call.arguments as? [String: Any],
               let center = arguments["center"] as? [String: Any],
               let latitude = center["latitude"] as? Double,
               let longitude = center["longitude"] as? Double,
               let id = arguments["id"] as? String,
               let fillColor = arguments["fillColor"] as? String,
               let strokeColor = arguments["strokeColor"] as? String,
               let radius = arguments["radius"] as? Double,
               let strokeWidth = arguments["strokeWidth"] as? Double,
               let zIndex = arguments["zIndex"] as? Double,
               let isVisible = arguments["isVisible"] as? Bool,
               let isDottedLine = arguments["isDottedLine"] as? Bool
            {
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                let circleOptions = CircleOptions(id: id,
                                                  coordinate: coordinate,
                                                  radius: radius,
                                                  fillColor: UIColor(hexString: fillColor),
                                                  strokeColor: UIColor(hexString: strokeColor),
                                                  strokeWidth: strokeWidth,
                                                  zIndex: zIndex,
                                                  isVisible: isVisible,
                                                  isDottedLine: isDottedLine)
                let circle = WazyCircle(id: id, options: circleOptions)
                
                mKMapView.addOverlay(circle)
            }
            
        } else if method == removeCircle {
            if let identifier = call.arguments as? String {
                let needRemovedOverlays = filterOverlays(.wazyCircle, ids: [identifier])
                if !needRemovedOverlays.isEmpty {
                    mKMapView.removeOverlays(needRemovedOverlays)
                }
            }
            
        } else if method == removeCircles {
            if let arguments = call.arguments as? [String: Any],
               let ids = arguments["ids"] as? [String]
            {
                let needRemovedOverlays = filterOverlays(.wazyCircle, ids: ids)
                if !needRemovedOverlays.isEmpty {
                    mKMapView.removeOverlays(needRemovedOverlays)
                }
            } else {
                let needRemovedOverlays = filterOverlays(.wazyCircle, ids: nil)
                if !needRemovedOverlays.isEmpty {
                    mKMapView.removeOverlays(needRemovedOverlays)
                }
            }
        } else if method == getCircles {
            var overlaysJson: [String: Any] = [:]
            for overlay in mKMapView.overlays {
                if overlay is WazyCircle {
                    let circle = overlay as! WazyCircle
                    overlaysJson[circle.id] = circle.toJson()
                }
            }
            
            result(overlaysJson)
        } else if method == addPolygon {
            if let arguments = call.arguments as? [String: Any],
               let id = arguments["id"] as? String,
               let pointsJson = arguments["points"] as? [[String: Double]],
               let fillColor = arguments["fillColor"] as? String,
               let strokeColor = arguments["strokeColor"] as? String,
               let strokeWidth = arguments["strokeWidth"] as? Double,
               let zIndex = arguments["zIndex"] as? Double,
               let isVisible = arguments["isVisible"] as? Bool,
               let isDottedLine = arguments["isDottedLine"] as? Bool
            {
                let points = pointsJson.map { pointJson -> CLLocationCoordinate2D in
                    let latitude = pointJson["latitude"]!
                    let longitude = pointJson["longitude"]!
                    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                }
                
                let polygonOptions = PolygonOptions(id: id,
                                                    points: points,
                                                    strokeWidth: strokeWidth,
                                                    fillColor: UIColor(hexString: fillColor),
                                                    strokeColor: UIColor(hexString: strokeColor),
                                                    zIndex: zIndex,
                                                    isVisible: isVisible,
                                                    isDottedLine: isDottedLine)
                
                let polygon = WazyPolygon(id: id, options: polygonOptions)
                mKMapView.addOverlay(polygon)
            }
            
        } else if method == removePolygon {
            if let identifier = call.arguments as? String {
                let needRemovedOverlays = filterOverlays(.wazyPolygon, ids: [identifier])
                if !needRemovedOverlays.isEmpty {
                    mKMapView.removeOverlays(needRemovedOverlays)
                }
            }
        } else if method == removePolygons {
            if let arguments = call.arguments as? [String: Any],
               let ids = arguments["ids"] as? [String]
            {
                let needRemovedOverlays = filterOverlays(.wazyPolygon, ids: ids)
                if !needRemovedOverlays.isEmpty {
                    mKMapView.removeOverlays(needRemovedOverlays)
                }
            } else {
                let needRemovedOverlays = filterOverlays(.wazyPolygon, ids: nil)
                if !needRemovedOverlays.isEmpty {
                    mKMapView.removeOverlays(needRemovedOverlays)
                }
            }
        } else if method == getPolygons {
            var overlaysJson: [String: Any] = [:]
            for overlay in mKMapView.overlays {
                if overlay is WazyPolygon {
                    let polygon = overlay as! WazyPolygon
                    overlaysJson[polygon.id] = polygon.toJson()
                }
            }
            
            result(overlaysJson)
        } else if method == addPolyline {
            if let arguments = call.arguments as? [String: Any],
               let id = arguments["id"] as? String,
               let pointsJson = arguments["points"] as? [[String: Double]],
               let color = arguments["color"] as? String,
               let width = arguments["width"] as? Double,
               let zIndex = arguments["zIndex"] as? Double,
               let isVisible = arguments["isVisible"] as? Bool,
               let isDottedLine = arguments["isDottedLine"] as? Bool
            {
                let points = pointsJson.map { pointJson -> CLLocationCoordinate2D in
                    let latitude = pointJson["latitude"]!
                    let longitude = pointJson["longitude"]!
                    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                }
                
                let polylineOptions = PolylineOptions(id: id, points: points,
                                                      width: width, color: UIColor(hexString: color), zIndex: zIndex, isDottedLine: isDottedLine, isVisible: isVisible)
                
                let polyline = WazyPolyline(id: id, options: polylineOptions)
                mKMapView.addOverlay(polyline)
            }
            
        } else if method == removePolyline {
            if let identifier = call.arguments as? String {
                let needRemovedOverlays = filterOverlays(.wazyPolyline, ids: [identifier])
                if !needRemovedOverlays.isEmpty {
                    mKMapView.removeOverlays(needRemovedOverlays)
                }
            }
        } else if method == removePolylines {
            if let arguments = call.arguments as? [String: Any],
               let ids = arguments["ids"] as? [String]
            {
                let needRemovedOverlays = filterOverlays(.wazyPolyline, ids: ids)
                if !needRemovedOverlays.isEmpty {
                    mKMapView.removeOverlays(needRemovedOverlays)
                }
            } else {
                let needRemovedOverlays = filterOverlays(.wazyPolyline, ids: nil)
                if !needRemovedOverlays.isEmpty {
                    mKMapView.removeOverlays(needRemovedOverlays)
                }
            }
        } else if method == getPolylines {
            var overlaysJson: [String: Any] = [:]
            for overlay in mKMapView.overlays {
                if overlay is WazyPolyline {
                    let polyline = overlay as! WazyPolyline
                    overlaysJson[polyline.id] = polyline.toJson()
                }
            }
            
            result(overlaysJson)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func filterOverlays(_ type: OverlayType, ids: [String]?) -> [MKOverlay] {
        let filterOverlays = mKMapView.overlays.filter { overlay -> Bool in
            if type == .wazyCircle {
                if overlay is WazyCircle {
                    if ids == nil || ids!.isEmpty {
                        return true
                    } else {
                        let circle = overlay as! WazyCircle
                        if ids!.contains(circle.id) {
                            return true
                        }
                    }
                }
            } else if type == .wazyPolygon {
                if overlay is WazyPolygon {
                    if ids == nil || ids!.isEmpty {
                        return true
                    } else {
                        let polygon = overlay as! WazyPolygon
                        if ids!.contains(polygon.id) {
                            return true
                        }
                    }
                }
            } else if type == .wazyPolyline {
                if overlay is WazyPolyline {
                    if ids == nil || ids!.isEmpty {
                        return true
                    } else {
                        let polyline = overlay as! WazyPolyline
                        if ids!.contains(polyline.id) {
                            return true
                        }
                    }
                }
            }
            
            return false
        }
        return filterOverlays
    }
    
    private func filterMarkers(_ ids: [String]?) -> [MKAnnotation] {
        let filterMarkers = mKMapView.annotations.filter { annotation -> Bool in
            if annotation is WazyMarker {
                if ids == nil || ids!.isEmpty {
                    return true
                } else {
                    let marker = annotation as! WazyMarker
                    if ids!.contains(marker.id) {
                        return true
                    }
                }
            }
            return false
        }
        return filterMarkers
    }
    
    public func view() -> UIView {
        return mKMapView
    }
}

enum OverlayType: Int {
    case wazyPolyline, wazyPolygon, wazyCircle
}

extension MKMapView {
    // 缩放级别
    var zoomLevel: Int {
        // 获取缩放级别
        get {
            return Int(log2(360 * (Double(frame.size.width / 256)
                    / region.span.longitudeDelta)) + 1)
        }
        // 设置缩放级别
        set(newZoomLevel) {
            setCenterCoordinate(coordinate: centerCoordinate, zoomLevel: newZoomLevel,
                                animated: false)
        }
    }
     
    // 设置缩放级别时调用
    private func setCenterCoordinate(coordinate: CLLocationCoordinate2D, zoomLevel: Int,
                                     animated: Bool)
    {
        let span = MKCoordinateSpan(latitudeDelta: 0.0,
                                    longitudeDelta: 360 / pow(2, Double(zoomLevel)) * Double(frame.size.width) / 256)
        setRegion(MKCoordinateRegion(center: centerCoordinate, span: span), animated: animated)
    }
}

extension UIColor {
    var hexString: String {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let redHex = String(format: "%02X", Int(red * 255))
            let greenHex = String(format: "%02X", Int(green * 255))
            let blueHex = String(format: "%02X", Int(blue * 255))
            let alphaHex = String(format: "%02X", Int(alpha * 255))
            return "#\(alphaHex)\(redHex)\(greenHex)\(blueHex)"
        } else {
            return "#ffffffff"
        }
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
