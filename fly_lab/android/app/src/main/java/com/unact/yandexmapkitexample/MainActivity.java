package com.unact.yandexmapkitexample;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

import com.yandex.mapkit.MapKitFactory;

public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    MapKitFactory.setLocale("YOUR_LOCALE");
    MapKitFactory.setApiKey("0cd953a8-82e7-4a01-8f57-9ce9ff6d8b49");
    super.configureFlutterEngine(flutterEngine);
  }
}