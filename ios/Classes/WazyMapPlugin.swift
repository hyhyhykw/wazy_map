import Flutter
import UIKit

public class WazyMapPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "wazy_map", binaryMessenger: registrar.messenger())
    
//    let controller = WazyViewController()
      
//    let instance = WazyMapPlugin(mapController: controller)
        let factory = WazyMapFactory(methodChannel: channel)
    
        registrar.register(factory, withId: "jlb_map",
                           gestureRecognizersBlockingPolicy:FlutterPlatformViewGestureRecognizersBlockingPolicyWaitUntilTouchesEnded)
    
//    registrar.addMethodCallDelegate(instance, channel: channel)
    }
//    let mapController: WazyViewController
//     init(mapController: WazyViewController) {
//         self.mapController = mapController
//    }

    //  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//      mapController.handle(call, result: result)
    //  }
}
