package com.wz.location.map;

import com.wz.location.map.model.BaseOptions;

public interface IMapLayer {

    void removeOverlay(String layerId);

    void updateOption(String layerId, BaseOptions polylineOptions);

    void removeAll();

}
