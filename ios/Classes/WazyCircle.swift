import Flutter
import MapKit
import UIKit
//
//  WazyCircle.swift
//  Pods
//
//  Created by 黄垚 on 2025/8/5.
//

class WazyCircle: MKCircle {
    let id: String
    let options: CircleOptions

    init(
        id: String,
        options: CircleOptions,
    ) {
        self.id = id
        self.options = options
        super.init(center: options.coordinate, radius: options.radius)
    }

    func toJson() -> [String: Any] {
        let map: [String: Any] = [
            "radius": radius,
            "id": id,
            "options": options.toJson(),
        ]
        return map
    }
}

class CircleOptions: NSObject {
    let id: String
    let fillColor: UIColor
    let strokeColor: UIColor
    let strokeWidth: Double
    let zIndex: Double
    let isVisible: Bool
    let isDottedLine: Bool
    let coordinate: CLLocationCoordinate2D
    let radius: CLLocationDistance
    
    init(
        id: String,
        coordinate: CLLocationCoordinate2D,
        radius: CLLocationDistance,
        fillColor: UIColor,
        strokeColor: UIColor,
        strokeWidth: Double,
        zIndex: Double,
        isVisible: Bool,
        isDottedLine: Bool
    ) {
        self.id = id
        self.coordinate = coordinate
        self.radius = radius
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
        self.zIndex = zIndex
        self.isVisible = isVisible
        self.isDottedLine = isDottedLine
        
        super.init()
    }

    func toJson() -> [String: Any] {
        let map: [String: Any] = [
            "id": id,
            "center": coordinate.toJson(),
            "fillColor": fillColor.hexString,
            "strokeColor": strokeColor.hexString,
            "strokeWidth": strokeWidth,
            "zIndex": zIndex,
            "isVisible": isVisible,
            "isDottedLine": isDottedLine,
        ]
        return map
    }
}

// class WazyCircleRenderer: MKOverlayRenderer {
//    override init(overlay: MKOverlay) {
//        super.init(overlay: overlay)
//    }
//
//    override func draw(_ rect: CGRect) {
//        guard let customOverlay = overlay as? WazyCircle else { return }
//
//        let context = UIGraphicsGetCurrentContext()
//
//        context?.saveGState()
//        UIColor.red.setStroke() // 设置颜色为红色
//        context?.setLineWidth(5) // 设置线条宽度为5
//        let path = UIBezierPath()
//
//
//        path.move(to: CGPoint(x: 0, y: 0)) // 移动到起点
//        path.addLine(to: CGPoint(x: rect.width, y: rect.height)) // 画一条线到终点
//        path.stroke() // 绘制路径
//        context?.restoreGState()
//    }
// }
