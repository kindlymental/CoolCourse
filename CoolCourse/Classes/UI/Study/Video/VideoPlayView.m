//
//  VideoPlayView.m
//  CoolCourse
//
//  Created by 刘怡兰 on 2019/1/10.
//  Copyright © 2019 lyl. All rights reserved.
//

#import "VideoPlayView.h"

#define TUTORIAL_VIDEO_VIEW_SHOW_FIRST   @"TUTORIAL_VIDEO_VIEW_SHOW_FIRST"

@interface VideoPlayView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, copy) void(^playBlock)(void);
@property (nonatomic, copy) void(^cancelBlock)(void);

@end

@implementation VideoPlayView

+ (void)showWithPlayBlock:(nullable void (^)(void))block
              cancelBlock:(nullable void (^)(void))cancelBlock {

    VideoPlayView *view = [[VideoPlayView alloc] initWithPlayBlock:block cancelBlock:cancelBlock];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

- (instancetype)initWithPlayBlock:(nullable void (^)(void))block
                      cancelBlock:(nullable void (^)(void))cancelBlock {
    if (self = [super init]) {
        _playBlock = [block copy];
        _cancelBlock = [cancelBlock copy];
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
        
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tutorial_alert_img"]];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"tutorial_alert_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickCloseAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"tutorial_alert_play"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(clickPlayAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_imageView];
        [self addSubview:_closeButton];
        [self addSubview:_playButton];
    }
    return self;
}

// tell UIKit that you are using AutoLayout
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

// this is Apple's recommended place for adding/updating constraints
- (void)updateConstraints {
    
    // --- remake/update constraints here
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.imageView.mas_leading).offset(4);
        make.bottom.mas_equalTo(self.imageView.mas_top).offset(-19);
    }];
    
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.imageView.mas_centerX);
        make.bottom.mas_equalTo(self.imageView.mas_bottom).offset(-29);
    }];
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}

#pragma mark - Event
// 关闭
- (void)clickCloseAction:(UIButton *)sender {
    if (_cancelBlock) {
        _cancelBlock();
    }
    
    [self removeFromSuperview];
}

// 播放视频
- (void)clickPlayAction:(UIButton *)sender {
    if (_playBlock) {
        _playBlock();
    }
    
    [self removeFromSuperview];
}

@end
