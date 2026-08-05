package com.vsp.vsp_2048

import android.os.Bundle
import androidx.core.view.WindowInsetsControllerCompat
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // The OS splash has a transparent icon and matching background (#121212),
        // so it is visually blank. Flutter's SplashContent widget shows
        // immediately underneath and owns the entire branded animation.
        installSplashScreen()
        super.onCreate(savedInstanceState)

        // Configure system bar appearance using non-deprecated APIs
        // FlutterActivity already calls setDecorFitsSystemWindows(false) for edge-to-edge
        val controller = WindowInsetsControllerCompat(window, window.decorView)
        controller.isAppearanceLightStatusBars = false
        controller.isAppearanceLightNavigationBars = false
    }
}
