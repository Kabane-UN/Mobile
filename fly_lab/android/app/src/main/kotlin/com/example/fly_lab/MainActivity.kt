package com.example.fly_lab

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory
class MainActivity: FlutterActivity() {
 override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
 MapKitFactory.setApiKey("0cd953a8-82e7-4a01-8f57-9ce9ff6d8b49") // Your generated API key
 super.configureFlutterEngine(flutterEngine)
 }
}

