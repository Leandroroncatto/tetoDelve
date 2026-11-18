FukkiCaptureScreen(region := "", &width := 0, &height := 0) {
    if (region != "") {
        if (region.Length < 4) {
            return 0
        }
        pBitmap := Gdip_BitmapFromScreen(region[1] "|" region[2] "|" region[3] "|" region[4])
    } else {
        pBitmap := Gdip_BitmapFromScreen()
    }

    if (pBitmap) {
        width := Gdip_GetImageWidth(pBitmap)
        height := Gdip_GetImageHeight(pBitmap)
    }
    return pBitmap
}
