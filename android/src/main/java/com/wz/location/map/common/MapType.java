package com.wz.location.map.common;

import androidx.annotation.NonNull;

import com.wz.location.map.util.Constants;

public enum MapType {

    DEFAULT(Constants.MAP_STYLE_DEFAULT),
    LIGHT_BLUE(Constants.MAP_STYLE_LIGHT_BLUE),
    GRAY_WHITE(Constants.MAP_STYLE_GRAY_WHITE),
    DARK_BLUE(Constants.MAP_STYLE_DARK_BLUE);

    private final String styleStr ;

    MapType(String type) {
        styleStr = type;
    }

    public String getStyleStr() {
        return styleStr;
    }

    @NonNull
    @Override
    public String toString() {
        return String.valueOf (styleStr);

    }
}
