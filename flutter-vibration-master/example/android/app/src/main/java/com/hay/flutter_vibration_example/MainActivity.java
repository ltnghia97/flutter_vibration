package com.hay.flutter_vibration_example;

import android.view.KeyEvent;
import com.hay.flutter_vibration.ActivityKeyEvent;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {


    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        ActivityKeyEvent activityKeyEvent = (ActivityKeyEvent)getFlutterEngine().getPlugins().get(com.hay.flutter_vibration.FlutterVibrationPlugin.class);
        activityKeyEvent.onKeyDown(keyCode,event);
        return super.onKeyDown(keyCode, event);
    }
}
