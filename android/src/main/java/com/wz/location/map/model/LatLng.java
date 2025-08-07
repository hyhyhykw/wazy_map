package com.wz.location.map.model;


import androidx.annotation.NonNull;

import java.io.Serializable;
import java.util.HashMap;

/**
 * 经纬度
 *
 * @author yihong.chen
 */
public final class LatLng implements Serializable {
    public LatLng(double lat, double lon) {
        this.lat = lat;
        this.lon = lon;
    }

    public double lat;
    public double lon;

    @NonNull
    public HashMap<String, Object> toArguments() {
        HashMap<String, Object> latMap = new HashMap<>();
        latMap.put("latitude", lat);
        latMap.put("longitude", lon);
        return latMap;
    }

}
