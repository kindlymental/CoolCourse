//
//  YXTutorialVideoControl.h
//  WasherV3
//
//  Created by mac on 2018/11/27.
//  Copyright © 2018年 厦门悠生活网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YXTutorialControlStatus) {
    YXTutorialControlStatusUnknown, // 初始状态
    YXTutorialControlStatusWAN,     // 非WiFi
    YXTutorialControlStatusPlaying, // 播放中
    YXTutorialControlStatusPaused,  // 暂停播放
    YXTutorialControlStatusEnded    // 播放结束
};

@protocol YXTutorialControlDelegate <NSObject>

// 关闭播放器
- (void)closePlayer;

// 播放视频
- (void)playVideo;

// 暂停播放
- (void)pauseVideo;

// 移动进度条
- (void)moveSlider:(float)seconds;

@end

@interface VideoPlayControlView : UIView

@property (nonatomic, strong) UILabel *titleLabel; // 标题

@property (nonatomic, strong) UIButton *closeButton; // 关闭
@property (nonatomic, strong) UIButton *playButton;  // 播放

@property (nonatomic, strong) UILabel *alertLabel;   // 未WiFi提示信息
@property (nonatomic, strong) UIButton *alertButton; // 非WiFi提示按钮

@property (nonatomic, strong) UILabel *startLabel; // 播放时间
@property (nonatomic, strong) UILabel *endLabel;   // 剩余时间
@property (nonatomic, strong) UISlider *slider;    // 播放进度

@property (weak, NS_NONATOMIC_IOSONLY, nullable) id<YXTutorialControlDelegate> delegate;

@property (nonatomic, assign) YXTutorialControlStatus status;

@end
