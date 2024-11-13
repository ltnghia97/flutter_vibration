#import "FlutterVibrationPlugin.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

static  SystemSoundID customSoundID;
static NSObject <FlutterPluginRegistrar> *pluginRegistrar = nil;

@implementation FlutterVibrationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  pluginRegistrar = registrar;
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_vibration"
            binaryMessenger:[registrar messenger]];
  FlutterVibrationPlugin* instance = [[FlutterVibrationPlugin alloc] init];
  [instance addVolumeObserver];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"play" isEqualToString:call.method]) {
      [self playAudio:call.arguments[@"uri"] vibration:call.arguments[@"vibration"]];
      result(nil);
  }else  if ([@"stop" isEqualToString:call.method]) {
      [self stopPlayAudio];
      result(nil);
    }
  else {
    result(FlutterMethodNotImplemented);
  }
}

-(void)playAudio:(NSString *)uri vibration:(BOOL)vibration{

    [self stopPlayAudio];
    
    if(vibration){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    if(uri && uri.length>0){
        //获取路径
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"h" ofType:@"m4r"];
        //定义一个带振动的SystemSoundID
        customSoundID = 1007;
        NSString *key = [pluginRegistrar lookupKeyForAsset:uri];
        NSURL *path = [[NSBundle mainBundle] URLForResource:key withExtension:nil];
        CFURLRef soundFileURLRef = CFBridgingRetain(path);

            //创建一个音频文件的播放系统声音服务器
            OSStatus error = AudioServicesCreateSystemSoundID(soundFileURLRef, &customSoundID);
            //判断是否有错误
            if (error != kAudioServicesNoError) {
                NSLog(@"kAudioServicesError %d",(int)error);
            }
            /*添加音频结束时的回调*/
            AudioServicesAddSystemSoundCompletion(customSoundID, NULL, NULL, SoundFinished, (__bridge void * _Nullable)(path));
    }else{
        customSoundID = (SystemSoundID)1007;
    }
        //只播放声音，没振动
    AudioServicesPlaySystemSound(customSoundID);

}

-(void)stopPlayAudio{
  AudioServicesDisposeSystemSoundID(customSoundID);
  customSoundID=0;
}

//当音频播放完毕会调用这个函数
static void SoundFinished(SystemSoundID soundID,void* sample){
    /*播放全部结束 */
    if (customSoundID==0) {
        return;
    }
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(soundID);
    //NSLog(@"播放结束 %u",(unsigned int)customSoundID);

}

- (void)addVolumeObserver
{
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [audioSession setActive:YES error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    [audioSession addObserver:self forKeyPath:@"outputVolume" options:NSKeyValueObservingOptionNew context:NULL];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"音量键监听");
    if (![keyPath isEqualToString:@"outputVolume"]) {
        return;
    }
    //NSLog(@"音量键监听");
    [self stopPlayAudio];

}
@end
