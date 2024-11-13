package com.hay.flutter_vibration;

import androidx.annotation.NonNull;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.graphics.PixelFormat;
import android.media.AudioManager;
import android.media.Ringtone;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;

import com.hay.flutter_vibration.services.RingtonePlayingService;

import java.lang.reflect.Method;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.KeyboardManager;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.ActivityLifecycleListener;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FlutterVibrationPlugin */
public class FlutterVibrationPlugin implements FlutterPlugin, MethodCallHandler,ActivityKeyEvent{
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;
  private RingtoneManager ringtoneManager;
  private Ringtone ringtone;

//  private Vibrator vibrator;



  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.context = flutterPluginBinding.getApplicationContext();
    this.ringtoneManager = new RingtoneManager(context);
    this.ringtoneManager.setStopPreviousRingtone(true);

//    vibrator = (Vibrator) context.getSystemService(Context.VIBRATOR_SERVICE);

    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_vibration");
    channel.setMethodCallHandler(this);

    Log.i("callringnoti","onattached");
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

    Log.i("callringnoti","ondetached");
    this.context = null;
    this.ringtoneManager = null;
    channel.setMethodCallHandler(null);

  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("play")) {
      play(call.argument("uri"));
      result.success("");
    } else  if (call.method.equals("stop")) {
      stop();
      result.success("");
    }else{
      result.notImplemented();
    }
  }

  public void play(String uri){
    Uri ringtoneUri = null;
    if(uri==null || uri.isEmpty()){
      ringtoneUri = RingtoneManager.getActualDefaultRingtoneUri(context, RingtoneManager.TYPE_RINGTONE);
    }else{
      ringtoneUri = Uri.parse(uri);
    }

//    if (ringtone != null) {
//      ringtone.stop();
//    }
//    ringtone = RingtoneManager.getRingtone(context, ringtoneUri);
//    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
//      ringtone.setLooping(true);
//    }
//    ringtone.setStreamType(AudioManager.STREAM_ALARM);
//    ringtone.play();

    Intent startIntent = new Intent(context, RingtonePlayingService.class);
    startIntent.putExtra("ringtone-uri", ringtoneUri.toString());
    context.startService(startIntent);

//    if(vibration){
//      long[] pattern = {1500, 800, 800, 800};
//      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//        vibrator.vibrate(VibrationEffect.createWaveform(pattern,0));
//      }else {
//        vibrator.vibrate(pattern, 0);
//      }
//    }
  }

  public void stop(){

    Log.i("callringnoti","stop");
//    RingtoneManager.getRingtone(context, RingtoneManager.getActualDefaultRingtoneUri(context, RingtoneManager.TYPE_RINGTONE)).stop();
//    if (ringtone != null) {
//      Log.i("callringnoti","stop 1");
//      ringtone.stop();
//    } else {Log.i("callringnoti","stop 3");
//      ringtoneManager.stopPreviousRingtone();
//    }
    Intent stopIntent = new Intent(context, RingtonePlayingService.class);
    context.stopService(stopIntent);

//    vibrator.cancel();
    Log.i("callringnoti","stop 2");
  }

  @Override
  public void onKeyDown(int keyCode, KeyEvent event) {

    Log.e("flutter","onKeyDown");
    stop();

  }
}
