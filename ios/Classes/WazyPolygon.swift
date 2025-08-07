import Flutter
import MapKit
import UIKit
//
//  WazyPolygon.swift
//  Pods
//
//  Created by 黄垚 on 2025/8/6.
//

class WazyPolygon: MKPolygon {
    let id: String
    let options: PolygonOptions
    init(
        id: String,
        options: PolygonOptions
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

class PolygonOptions: NSObject {
    let id: String
    let points: [CLLocationCoordinate2D]
    let strokeWidth: Double
    let fillColor: UIColor
    let strokeColor: UIColor
    let zIndex: Double
    let isVisible: Bool
    let isDottedLine: Bool

    init(
        id: String,
        points: [CLLocationCoordinate2D],
        strokeWidth: Double,
        fillColor: UIColor,
        strokeColor: UIColor,
        zIndex: Double,
        isVisible: Bool,
        isDottedLine: Bool,

    ) {
        self.id = id
        self.points = points
        self.strokeWidth = strokeWidth
        self.fillColor = fillColor
        self.strokeColor = strokeColor
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
