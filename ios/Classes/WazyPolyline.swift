import Flutter
import MapKit
import UIKit
//
//  WazyPolygon.swift
//  Pods
//
//  Created by 黄垚 on 2025/8/6.
//

class WazyPolyline: MKPolyline {
    let id: String
    let options: PolylineOptions
    init(
        id: String,
        options: PolylineOptions
    ) {
        self.id = id
        self.options = options
        super.init(coordinates: options.points, count: options.points.count)
    }

    func toJson() -> [String: Any] {
        let map: [String: Any] = [
            "id": id,
            "options": options.toJson(),
        ]
        return map
    }
}

class PolylineOptions: NSObject {
    let points: [CLLocationCoordinate2D]
    let id: String
    let width: Double
    let color: UIColor
    let zIndex: Double
    let isDottedLine: Bool
    let isVisible: Bool

    init(
        id: String,
        points: [CLLocationCoordinate2D],
        width: Double,
        color: UIColor,
        zIndex: Double,
        isDottedLine: Bool,
        isVisible: Bool,

    ) {
        self.id = id
        self.points = points
        self.width = width
        self.color = color
        self.zIndex = zIndex
        self.isDottedLine = isDottedLine
        self.isVisible = isVisible
        super.init()
    }

    func toJson() -> [String: Any] {
        let pointsJson = points.map { point -> [String: Any] in
            point.toJson()
        }
        let map: [String: Any] = [
            "id": id,
            "points": pointsJson,
            "width": width,
            "color": color.hexString,
            "zIndex": zIndex,
            "isVisible": isVisible,
            "isDottedLine": isDottedLine,
        ]
        return map
    }
}
