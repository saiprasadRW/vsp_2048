package com.vsp.vsp_2048

import android.os.Bundle
import androidx.core.view.WindowInsetsControllerCompat
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        installSplashScreen()
        super.onCreate(savedInstanceState)

        // Use WindowInsetsControllerCompat for system bar appearance (non-deprecated)
        // Edge-to-edge is enforced via android:windowOptOutEdgeToEdgeEnforcement=false
        // in NormalTheme (styles.xml) — the recommended approach for SDK 35+
        val controller = WindowInsetsControllerCompat(window, window.decorView)
        controller.isAppearanceLightStatusBars = false
        controller.isAppearanceLightNavigationBars = false
    }
}
