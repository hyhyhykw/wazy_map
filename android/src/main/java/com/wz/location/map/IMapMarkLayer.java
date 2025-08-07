package com.wz.location.map;

public interface IMapMarkLayer {
    void showInfoWindow(String markerId);

    void hideInfoWindow(String markerId);

    boolean isInfoWindowShown(String markerId);

    void removeOverlay(String markId);
}
