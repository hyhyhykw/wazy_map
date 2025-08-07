package com.jlb.map;

import androidx.annotation.NonNull;

import com.wz.location.map.util.WzManager;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodChannel;

/**
 * WazyMapPlugin
 */
public class WazyMapPlugin implements FlutterPlugin {

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        // The MethodChannel that will the communication between Flutter and native Android
        //
        // This local reference serves to register the plugin with the Flutter Engine and unregister it
        // when the Flutter Engine is detached from the Activity
        MethodChannel channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "wazy_map");
//        channel.setMethodCallHandler(this);
        FlutterAssets flutterAssets = flutterPluginBinding.getFlutterAssets();
        WzManager.getInstance(flutterPluginBinding.getApplicationContext());
        flutterPluginBinding.getPlatformViewRegistry().registerViewFactory("jlb_map", new WazyMapFactory(channel, flutterAssets));
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

    }

}
