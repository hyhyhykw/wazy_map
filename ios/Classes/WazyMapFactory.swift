import Flutter
//
//  WazyMapFactory.swift
//  Pods
//
//  Created by 黄垚 on 2025/8/5.
//

public class WazyMapFactory: NSObject, FlutterPlatformViewFactory {
    private let methodChannel: FlutterMethodChannel
    
    init(methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
    }
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
      
        return WazyMapView(frame, viewID: viewId, methodChannel: self.methodChannel)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
