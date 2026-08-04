package com.vsp.vsp_2048

import android.os.Bundle
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // The OS splash has a transparent icon and matching background (#121212),
        // so it is visually blank. Flutter's SplashContent widget shows
        // immediately underneath and owns the entire branded animation.
        installSplashScreen()
        super.onCreate(savedInstanceState)
    }
}
