//
//  YXPlayer.h
//  WasherV3
//
//  Created by mac on 2018/11/28.
//  Copyright © 2018年 厦门悠生活网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif /* __has_include */

@protocol YXPlayerDelegate <NSObject>

/**
 网络环境变化
 */
- (void)reachabilityStatusChange:(AFNetworkReachabilityStatus)status;

/**
 遇到错误

 @param message 错误信息
 */
- (void)failed:(NSString *)message;

/**
 准备播放

 @param duration 总时长
 */
- (void)readyToPlay:(Float64)duration;

/**
 播放结束
 */
- (void)playToEndTime;

/**
 播放时间进度变化
 */
- (void)periodicTimeObserverForInterval:(Float64)seconds;

@end

@interface YXPlayer : NSObject

@property (nonatomic, strong) AVPlayerLayer *layer;
@property (weak, NS_NONATOMIC_IOSONLY, nullable) id<YXPlayerDelegate> delegate;
@property (nonatomic, assign) BOOL onlyPlayOnWiFi; // 只有在WiFi情况下播放，默认YES

- (instancetype)initWithURL:(NSString *)url;

/**
 播放视频
 */
- (void)play;

/**
 暂停
 */
- (void)pause;

/**
 回放
 */
- (void)playback;

/**
 快进/快退
 */
- (void)seekToTime:(Float64)seconds;

@end
