package com.hay.flutter_vibration.services;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.media.AudioAttributes;
import android.media.AudioManager;
import android.media.Ringtone;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.os.IBinder;
import android.os.VibrationEffect;
import android.os.Vibrator;

import java.util.Timer;
import java.util.TimerTask;

public class RingtonePlayingService extends Service
{
    private Ringtone ringtone;
    private Vibrator vibrator;

    private boolean isPlaying;

    private Timer timer = new Timer();

    private TimerTask timerTask;

    @Override
    public IBinder onBind(Intent intent)
    {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId)
    {
        if (isPlaying) {
            stop();
        }
        isPlaying = true;
        vibrator = (Vibrator) this.getSystemService(Context.VIBRATOR_SERVICE);
        long[] pattern = {1500, 800, 800, 800};
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            vibrator.vibrate(VibrationEffect.createWaveform(pattern,0), new AudioAttributes.Builder()
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .build());
        }else {
            vibrator.vibrate(pattern, 0);
        }

        Uri ringtoneUri = Uri.parse(intent.getExtras().getString("ringtone-uri"));

        ringtone = RingtoneManager.getRingtone(this, ringtoneUri);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            ringtone.setLooping(true);
        }
        ringtone.setStreamType(AudioManager.STREAM_RING);
        ringtone.play();
        if (timerTask != null) {
            timerTask.cancel();
        }
        timerTask = new TimerTask() {
            @Override
            public void run() {
                stop();
                timerTask = null;
            }
        };
        timer.schedule(timerTask, 30000);

        return START_NOT_STICKY;
    }

    @Override
    public void onDestroy()
    {
        stop();
        timer.cancel();
    }

    private void stop() {
        vibrator.cancel();
        ringtone.stop();
        isPlaying = false;
    }
}
