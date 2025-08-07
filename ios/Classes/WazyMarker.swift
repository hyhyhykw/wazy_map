import Flutter
import MapKit
import UIKit
//
//  WazyMarker.swift
//  Pods
//
//  Created by 黄垚 on 2025/8/5.
//
class WazyMarker: NSObject, MKAnnotation {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let options: MarkerOptions
    init(id: String, coordinate: CLLocationCoordinate2D, options: MarkerOptions) {
        self.id = id
        self.coordinate = coordinate
        self.options = options
        super.init()
    }
    
    public func toJson() -> [String: Any] {
        let map: [String: Any] = [
            "id": id,
            "lat": coordinate.toJson(),
            "options": options.toJson()
        ]
        
        return map
    }
}

class MarkerOptions {
    let position: CLLocationCoordinate2D
    let title: String
    let snippet: String
    let iconPath: String
    let isFile: Bool
    let isDraggable: Bool
    let params: [String: Any]
    let width: Int
    let height: Int
    
    init(
        position: CLLocationCoordinate2D,
        title: String,
        snippet: String,
        iconPath: String,
        isFile: Bool,
        isDraggable: Bool,
        params: [String: Any],
        width: Int,
        height: Int,
    ) {
        self.position = position
        self.title = title
        self.snippet = snippet
        self.iconPath = iconPath
        self.isFile = isFile
        self.isDraggable = isDraggable
        self.params = params
        self.width = width
        self.height = height
    }
    
    public func toJson() -> [String: Any] {
        let map: [String: Any] = [
            "position": position.toJson(),
            "title": title,
            "snippet": snippet,
            "width": width,
            "height": height,
            "params": params,
            "draggable": isDraggable
        ]
        
        return map
    }
}

class MarkerView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configure()
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
     
    private func configure() {
        canShowCallout = false // 允许显示标注的气泡框（callout）
        
        if let annotation = annotation as? WazyMarker {
            let options = annotation.options
//            print("options====>"+options.iconPath)
//            print("isFile====>"+options.isFile)
            
//            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: options.width, height: options.height)) // 设置图片大小
            if options.isFile {
                
                let filePath = options.iconPath
//                let image = UIImage(contentsOfFile: filePath)
//                imageView.image = image
                
                if let imageData = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
                    let image = UIImage(data: imageData) {
                    
                   let resizedImage = image.resized(to: CGSize(width: options.width, height: options.height))
                    // 成功加载图像
                    print("成功加载图像")
                    self.image = resizedImage
                } else {
                    print("数据加载失败或图像损坏")
                }
                
//                if let path = Bundle.main.path(forResource: filePath, ofType: "png"),
//                    let image = UIImage(contentsOfFile: path) {
//                    imageView.image = image
//                }
                
//                if FileManager.default.fileExists(atPath: filePath) {
//                    let image = UIImage(contentsOfFile: filePath)
//                    imageView.image = image
//                } else {
//                    print("File does not exist at path: \(filePath)")
//                }
                
           
            } else {
                let image = flutterImage(options: options)
                if image != nil {
                    self.image = image
                }
            }
            
//            self.image
            
//               imageView.image = UIImage(named: annotation?.imageName ?? "defaultImage") // 设置图片名称，确保项目中存在该图片文件
//                self.leftCalloutAccessoryView = imageView // 设置气泡框左侧视图为图片视图
//                self.rightCalloutAccessoryView = UIButton(type: .detailDisclosureButton) // 可选：添加一个详情按钮在气泡框右侧
        }
    }
    
    private func flutterImage(options: MarkerOptions) -> UIImage? {
        let name: String = options.iconPath
        let fileName: String = NSString(string: name).lastPathComponent
        let path: String = NSString(string: name).deletingLastPathComponent
        
        let scaleArr: [Int] = (2 ... Int(UIScreen.main.scale)).reversed()

        for scale in scaleArr {
            let key: String = lookupKeyForAsset(asset: String(format: "%s/%d.0x/%s", path, scale, fileName), package: "")
            let image = UIImage(named: key, in: Bundle.main, compatibleWith: nil)
            if image != nil {
                return image!
            }
        }

        let key = lookupKeyForAsset(asset: name, package: "")
        return UIImage(named: key, in: Bundle.main, compatibleWith: nil)
    }
    
    private func lookupKeyForAsset(asset: String, package: String?) -> String {
        if let package = package, package != "" {
            return FlutterDartProject.lookupKey(forAsset: asset, fromPackage: package)
        } else {
            return FlutterDartProject.lookupKey(forAsset: asset)
        }
    }
}

public extension CLLocationCoordinate2D {
    func toJson() -> [String: Any] {
        let latJson: [String: Any] = [
            "latitude": latitude,
            "longitude": longitude
        ]
        return latJson
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
