package com.jlb.map;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class WazyMapFactory extends PlatformViewFactory {
    private final MethodChannel channel;
    private  final FlutterPlugin.FlutterAssets flutterAssets;

    public WazyMapFactory(MethodChannel channel, FlutterPlugin.FlutterAssets flutterAssets) {
        super(StandardMessageCodec.INSTANCE);
        this.channel = channel;
        this.flutterAssets = flutterAssets;
    }

    @NonNull
    @Override
    public PlatformView create(Context context, int viewId, @Nullable Object args) {
        return new WazyMap(context, viewId, channel,flutterAssets);
    }
}
