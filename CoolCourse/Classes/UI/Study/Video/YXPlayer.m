//
//  YXPlayer.m
//  WasherV3
//
//  Created by mac on 2018/11/28.
//  Copyright © 2018年 厦门悠生活网络科技. All rights reserved.
//

#import "YXPlayer.h"

struct YXPlayerDelegateAvailableMethods {
    BOOL reachabilityStatusChange : 1;
    BOOL failed : 1;
    BOOL readyToPlay : 1;
    BOOL playToEndTime : 1;
    BOOL periodicTimeObserverForInterval : 1;
};
typedef struct YXPlayerDelegateAvailableMethods YXPlayerDelegateAvailableMethods;

@interface YXPlayer ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVURLAsset *asset;
@property (nonatomic, strong) AVPlayerItem *item;

@property (nonatomic, strong) NSString *currentURLString; // 当前播放视频地址

@property (atomic, readonly) YXPlayerDelegateAvailableMethods availableMethods;

@property (nonatomic, strong) id timeObserver;

@end

@implementation YXPlayer

- (instancetype)initWithURL:(NSString *)url {
    if (self = [super init]) {
        [self initialize];
        _currentURLString = url;
    }
    return self;
}

- (void)initialize {
    _player = [[AVPlayer alloc] init];
    _layer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _onlyPlayOnWiFi = YES;
    
    __weak __typeof(self) weakself = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (weakself.availableMethods.reachabilityStatusChange) {
            [weakself.delegate reachabilityStatusChange:status];
        }

        if ((status == AFNetworkReachabilityStatusReachableViaWiFi || (!weakself.onlyPlayOnWiFi && status == AFNetworkReachabilityStatusReachableViaWWAN)) && !weakself.item) {
            // WiFi情况下媒体未加载，则加载媒体
            [self loadMedia:weakself.currentURLString];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark - Set/Get

- (void)setDelegate:(id<YXPlayerDelegate>)delegate {
    _delegate = delegate;
    
    _availableMethods = (YXPlayerDelegateAvailableMethods){
        .reachabilityStatusChange = [delegate respondsToSelector:@selector(reachabilityStatusChange:)],
        .failed = [delegate respondsToSelector:@selector(failed:)],
        .readyToPlay = [delegate respondsToSelector:@selector(readyToPlay:)],
        .playToEndTime = [delegate respondsToSelector:@selector(playToEndTime)],
        .periodicTimeObserverForInterval = [delegate respondsToSelector:@selector(periodicTimeObserverForInterval:)],
    };
}

- (void)setItem:(AVPlayerItem *)item {
    [self removeObserver];
    _item = item;
    [self addObserver];
}

#pragma mark - Load Media
// 加载媒体资源
- (void)loadMedia:(NSString *)urlString {
    NSURL *mediaURL = [NSURL URLWithString:urlString];
//    _asset = [[AVURLAsset alloc] initWithURL:mediaURL options:nil];
//    _item = [AVPlayerItem playerItemWithAsset:_asset];
    self.item = [AVPlayerItem playerItemWithURL:mediaURL];
    [_player replaceCurrentItemWithPlayerItem:_item];
}

#pragma mark - Event

/**
 播放视频
 */
- (void)play {
    if (!_item) {
        [self loadMedia:_currentURLString];
    }
    
    [_player play];
    
    // 监听播放时间进度
    __weak __typeof(self) weakself = self;
    _timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 60) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        Float64 seconds = CMTimeGetSeconds(time);
        if (weakself.availableMethods.periodicTimeObserverForInterval) {
            [weakself.delegate periodicTimeObserverForInterval:seconds];
        }
    }];
}

/**
 暂停
 */
- (void)pause {
    [_player pause];
    
    // 移除时间进度的监听
    if (_timeObserver) {
        [_player removeTimeObserver:_timeObserver];
        _timeObserver = nil;
    }
}

/**
 回放
 */
- (void)playback {
    [_player seekToTime:kCMTimeZero];
    [self play];
}

/**
 快进/快退
 */
- (void)seekToTime:(Float64)seconds {
    [self pause];
    // 从指定的CMTime对象处播放
    CMTime startTime = CMTimeMakeWithSeconds(seconds, self.item.currentTime.timescale);
    // 让视频从指定处播放
    __weak __typeof(self) weakself = self;
    [_player seekToTime:startTime completionHandler:^(BOOL finished) {
        if (finished) {
            [weakself play]; // 播放
        }
    }];
}

#pragma mark - KVO

- (void)addObserver {
    // 监听状态属性
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监听当视频播放结束时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayToEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.item];
}

- (void)removeObserver {
    // 移除状态属性监听
    [self.item removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        switch (_item.status) {
            case AVPlayerItemStatusUnknown:
            {}
                break;
            case AVPlayerItemStatusReadyToPlay:
            {
                // 总时长
                NSTimeInterval seconds = CMTimeGetSeconds(_item.duration);
                if (self.availableMethods.readyToPlay) {
                    [self.delegate readyToPlay:seconds];
                }
            }
                break;
            case AVPlayerItemStatusFailed:
            {
                if (self.availableMethods.failed) {
                    [self.delegate failed:@"网络资源加载失败！"];
                }
            }
                break;
        }
    }
}

// 播放完成通知
- (void)didPlayToEndTimeNotification:(NSNotification *)notice {
    // 移除时间进度的监听
    if (_timeObserver) {
        [_player removeTimeObserver:_timeObserver];
        _timeObserver = nil;
    }
    
    if (self.availableMethods.playToEndTime) {
        [self.delegate playToEndTime];
    }
}

- (void)dealloc {
    [self removeObserver];
}

@end
