//
//  YXTutorialVideoControl.m
//  WasherV3
//
//  Created by mac on 2018/11/27.
//  Copyright © 2018年 厦门悠生活网络科技. All rights reserved.
//

#import "VideoPlayControlView.h"
#import "ULTimer.h"
#import "VideoConstant.h"

struct YXTutorialControlDelegateAvailableMethods {
    BOOL closePlayer : 1;
    BOOL playVideo : 1;
    BOOL pauseVideo : 1;
    BOOL moveSlider : 1;
};
typedef struct YXTutorialControlDelegateAvailableMethods YXTutorialControlDelegateAvailableMethods;

@interface VideoPlayControlView ()

@property (atomic, readonly) YXTutorialControlDelegateAvailableMethods availableMethods;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation VideoPlayControlView

- (instancetype)init {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.1];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenControl)];
        [self addGestureRecognizer:tap];

        [self addSubview:self.titleLabel];
        [self addSubview:self.closeButton];
        [self addSubview:self.playButton];
        [self addSubview:self.alertLabel];
        [self addSubview:self.alertButton];
        [self addSubview:self.startLabel];
        [self addSubview:self.endLabel];
        [self addSubview:self.slider];
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
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).with.offset(22);
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(13);
        make.top.equalTo(self.mas_top).with.offset(22);
    }];
    
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
    [_alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.alertButton.mas_top).with.offset(-20);
    }];
    
    [_alertButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(86);
        make.height.mas_equalTo(26);
    }];
    
    [_startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-21);
    }];
    
    [_endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).offset(-15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-21);
    }];
    
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.startLabel.mas_trailing).offset(12);
        make.trailing.mas_equalTo(self.endLabel.mas_leading).offset(-12);
        make.centerY.mas_equalTo(self.startLabel);
    }];
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}

#pragma mark - Set

- (void)setDelegate:(id<VideoControlDelegate>)delegate {
    _delegate = delegate;
    
    _availableMethods = (YXTutorialControlDelegateAvailableMethods){
        .closePlayer = [delegate respondsToSelector:@selector(closePlayer)],
        .playVideo = [delegate respondsToSelector:@selector(playVideo)],
        .pauseVideo = [delegate respondsToSelector:@selector(pauseVideo)],
        .moveSlider = [delegate respondsToSelector:@selector(moveSlider:)],
    };
}

- (void)setStatus:(VideoControlStatus)status {
    _status = status;
    self.hidden = NO;
    _alertLabel.hidden = YES;
    _alertButton.hidden = YES;
    _playButton.hidden = NO;
    
    switch (_status) {
        case VideoControlStatusUnknown: // 初始状态
            {
                
            }
            break;
        case VideoControlStatusWAN: // 非WiFi
            {
                _alertLabel.hidden = NO;
                _alertButton.hidden = NO;
                _playButton.hidden = YES;
            }
            break;
        case VideoControlStatusPlaying: // 播放中
            {
                [_playButton setImage:[UIImage imageNamed:videoConstant_pause_image] forState:UIControlStateNormal];
                [self hiddenWhenPlay];
            }
            break;
        case VideoControlStatusPaused: // 暂停播放
            {
                [_playButton setImage:[UIImage imageNamed:videoConstant_play_image] forState:UIControlStateNormal];
            }
            break;
        case VideoControlStatusEnded: // 播放结束
            {
                [_playButton setImage:[UIImage imageNamed:videoConstant_replay_image] forState:UIControlStateNormal];
            }
            break;
    }
}

#pragma mark - Event
// 关闭播放器
- (void)clickCloseAction:(UIButton *)sender {
    if (_availableMethods.closePlayer) {
        [_delegate closePlayer];
    }
}

// 控制播放
- (void)clickPlayControlAction:(UIButton *)sender {
    if (_status != VideoControlStatusPlaying) {
        // 播放视频
        if (_availableMethods.playVideo) {
            [_delegate playVideo];
        }
        
        self.status = VideoControlStatusPlaying;
    } else {
        // 暂停播放
        if (_availableMethods.pauseVideo) {
            [_delegate pauseVideo];
        }
        
        self.status = VideoControlStatusPaused;
    }
}

// 非WiFi下播放
- (void)clickWANPlayAction:(UIButton *)sender {
    self.status = VideoControlStatusPlaying;
    if (_availableMethods.playVideo) {
        [_delegate playVideo];
    }
}

// 开始移动进度条
- (void)startSliderAction:(UISlider *)sender {
    // 暂停播放
    if (_availableMethods.pauseVideo) {
        [_delegate pauseVideo];
    }
    
    self.status = VideoControlStatusPaused;
}

// 结束移动进度条
- (void)moveSliderAction:(UISlider *)sender {
    if (_availableMethods.moveSlider) {
        [_delegate moveSlider:sender.value];
    }
    
    self.status = VideoControlStatusPlaying;
}

// 点击背景隐藏视图
- (void)hiddenControl {
    if (self.status == VideoControlStatusPlaying) {
        self.hidden = YES;
    }
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    
    [self hiddenWhenPlay];
}

// 播放时隐藏
- (void)hiddenWhenPlay {
    if (_timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
    
    if (self.hidden == NO && _status == VideoControlStatusPlaying) {
        _timer = [ULTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(hiddenControl) userInfo:nil repeats:NO];
    }
}

#pragma mark -

#pragma mark - 懒加载

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Font18px;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"视频";
    }
    return _titleLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:videoConstant_close_image] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.enabled = NO;
        [_playButton setImage:[UIImage imageNamed:videoConstant_startPlay_image] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(clickPlayControlAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UILabel *)alertLabel {
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc] init];
        _alertLabel.font = Font15px;
        _alertLabel.textColor = [UIColor whiteColor];
        _alertLabel.hidden = YES;
        _alertLabel.text = @"播放将消耗流量";
    }
    return _alertLabel;
}

- (UIButton *)alertButton {
    if (!_alertButton) {
        _alertButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _alertButton.backgroundColor = RGB(74, 142, 209);
        _alertButton.layer.cornerRadius = 3.0f;
        _alertButton.titleLabel.font = Font15px;
        [_alertButton setTitle:@"继续播放" forState:UIControlStateNormal];
        _alertButton.hidden = YES;
        [_alertButton addTarget:self action:@selector(clickWANPlayAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _alertButton;
}

- (UILabel *)startLabel {
    if (!_startLabel) {
        _startLabel = [[UILabel alloc] init];
        _startLabel.font = Font11px;
        _startLabel.textColor = [UIColor whiteColor];
        _startLabel.text = @"00:00";
    }
    return _startLabel;
}

- (UILabel *)endLabel {
    if (!_endLabel) {
        _endLabel = [[UILabel alloc] init];
        _endLabel.font = Font11px;
        _endLabel.textColor = [UIColor whiteColor];
        _endLabel.text = @"00:00";
    }
    return _endLabel;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        [_slider setThumbImage:[UIImage imageNamed:videoConstant_sliderThumb_image] forState:UIControlStateNormal];
        [_slider setMinimumTrackImage:[UIImage imageNamed:videoConstant_sliderMinimum_image] forState:UIControlStateNormal];
        [_slider setMaximumTrackImage:[UIImage imageNamed:videoConstant_sliderMaximum_image] forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(moveSliderAction:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchCancel|UIControlEventTouchUpOutside];
        [_slider addTarget:self action:@selector(startSliderAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _slider;
}


@end
