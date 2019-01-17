//
//  StudyVideoPlayViewController.m
//  CoolCourse
//
//  Created by 刘怡兰 on 2019/1/13.
//  Copyright © 2019 lyl. All rights reserved.
//

#import "StudyVideoPlayViewController.h"
#import "VideoPlayControlView.h"
#import "YXPlayer.h"

@interface StudyVideoPlayViewController () <YXTutorialControlDelegate, YXPlayerDelegate>

@property (nonatomic,strong) VideoPlayControlView *control;
@property (nonatomic, strong) YXPlayer *player;

@end

@implementation StudyVideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showControl)];
    [self.view addGestureRecognizer:tap];
    [self initPlayer];
    [self initControl];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self closePlayer];
}

// 初始化播放器
- (void)initPlayer {
    _player = [[YXPlayer alloc] initWithURL:self.videoUrl];
    _player.delegate = self;
    _player.layer.frame = [UIScreen mainScreen].bounds;
    [self.view.layer addSublayer:_player.layer];
}

// 初始化UI控件
- (void)initControl {
    _control = [[VideoPlayControlView alloc] init];
    _control.delegate = self;
    [self.view addSubview:_control];
}

#pragma mark - Event

// 点击背景隐藏视图
- (void)showControl {
    self.control.hidden = NO;
}

#pragma mark - YXTutorialControlDelegate
// 关闭播放器
- (void)closePlayer {
    [self pauseVideo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 播放视频
- (void)playVideo {
    if (self.control.status == YXTutorialControlStatusEnded) {
        // 视频回放
        [self.player playback];
        return;
    } else if (self.control.status == YXTutorialControlStatusWAN) {
        // 非WiFi下也允许播放
        self.player.onlyPlayOnWiFi = NO;
    }
    
    [self.player play];
}

// 暂停播放
- (void)pauseVideo {
    [self.player pause];
}

// 移动进度条
- (void)moveSlider:(float)seconds {
    [self.player seekToTime:seconds];
}

#pragma mark - YXPlayerDelegate

/**
 网络环境变化
 */
- (void)reachabilityStatusChange:(AFNetworkReachabilityStatus)status {
    if (status == AFNetworkReachabilityStatusReachableViaWWAN && self.player.onlyPlayOnWiFi) {
        self.control.status = YXTutorialControlStatusWAN;
    }
}

/**
 遇到错误
 
 @param message 错误信息
 */
- (void)failed:(NSString *)message {
    NSLog(@"失败");
}

/**
 准备播放
 
 @param duration 总时长
 */
- (void)readyToPlay:(Float64)duration {
    NSInteger min = duration / 60;
    NSInteger sec = (NSInteger)duration % 60;
    _control.endLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", min, sec];
    _control.slider.minimumValue = 0;
    _control.slider.maximumValue = duration;
    _control.playButton.enabled = YES;
}

/**
 播放结束
 */
- (void)playToEndTime {
    self.control.status = YXTutorialControlStatusEnded;
}

/**
 播放时间进度变化
 */
- (void)periodicTimeObserverForInterval:(Float64)seconds {
    NSInteger min = seconds / 60;
    NSInteger sec = (NSInteger)seconds % 60;
    self.control.startLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", min, sec];
    self.control.slider.value = seconds;
}

@end
