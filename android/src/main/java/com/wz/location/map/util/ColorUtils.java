package com.wz.location.map.util;

public final class ColorUtils {


    /**
     * 将int类型的颜色值转换为ARGB的十六进制字符串。
     *
     * @param color int 颜色值 (例如: 0xAARRGGBB)
     * @return ARGB的十六进制字符串 (例如: "#AARRGGBB")
     */
    public static String intToARGBHex(int color) {
        int alpha = (color >> 24) & 0xFF;
        int red = (color >> 16) & 0xFF;
        int green = (color >> 8) & 0xFF;
        int blue = color & 0xFF;

        return String.format("#%02X%02X%02X%02X", alpha, red, green, blue);
    }
}
