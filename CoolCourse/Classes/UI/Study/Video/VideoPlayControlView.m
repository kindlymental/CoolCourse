//
//  YXTutorialVideoControl.m
//  WasherV3
//
//  Created by mac on 2018/11/27.
//  Copyright © 2018年 厦门悠生活网络科技. All rights reserved.
//

#import "VideoPlayControlView.h"
#import "ULTimer.h"

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
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = Font22px;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"视频教学";
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"tutorial_video_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickCloseAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.enabled = NO;
        [_playButton setImage:[UIImage imageNamed:@"dt_chinese_read_play_btn"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(clickPlayControlAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _alertLabel = [[UILabel alloc] init];
        _alertLabel.font = Font15px;
        _alertLabel.textColor = [UIColor whiteColor];
        _alertLabel.text = @"播放将消耗4M流量";
        _alertLabel.hidden = YES;
        
        _alertButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _alertButton.backgroundColor = RGB(74, 142, 209);
        _alertButton.layer.cornerRadius = 3.0f;
        _alertButton.titleLabel.font = Font15px;
        [_alertButton setTitle:@"继续播放" forState:UIControlStateNormal];
        _alertButton.hidden = YES;
        [_alertButton addTarget:self action:@selector(clickWANPlayAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _startLabel = [[UILabel alloc] init];
        _startLabel.font = Font11px;
        _startLabel.textColor = [UIColor whiteColor];
        _startLabel.text = @"00:00";
        
        _endLabel = [[UILabel alloc] init];
        _endLabel.font = Font11px;
        _endLabel.textColor = [UIColor whiteColor];
        _endLabel.text = @"00:00";
        
        _slider = [[UISlider alloc] init];
        [_slider setThumbImage:[UIImage imageNamed:@"tutorial_video_slider_thumb"] forState:UIControlStateNormal];
        [_slider setMinimumTrackImage:[UIImage imageNamed:@"tutorial_video_slider_minimum"] forState:UIControlStateNormal];
        [_slider setMaximumTrackImage:[UIImage imageNamed:@"tutorial_video_slider_maximum"] forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(moveSliderAction:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchCancel|UIControlEventTouchUpOutside];
        [_slider addTarget:self action:@selector(startSliderAction:) forControlEvents:UIControlEventTouchDown];

        [self addSubview:_titleLabel];
        [self addSubview:_closeButton];
        [self addSubview:_playButton];
        [self addSubview:_alertLabel];
        [self addSubview:_alertButton];
        [self addSubview:_startLabel];
        [self addSubview:_endLabel];
        [self addSubview:_slider];
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
        make.top.equalTo(self.mas_top).with.offset(32);
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(13);
        make.top.equalTo(self.mas_top).with.offset(32);
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

- (void)setDelegate:(id<YXTutorialControlDelegate>)delegate {
    _delegate = delegate;
    
    _availableMethods = (YXTutorialControlDelegateAvailableMethods){
        .closePlayer = [delegate respondsToSelector:@selector(closePlayer)],
        .playVideo = [delegate respondsToSelector:@selector(playVideo)],
        .pauseVideo = [delegate respondsToSelector:@selector(pauseVideo)],
        .moveSlider = [delegate respondsToSelector:@selector(moveSlider:)],
    };
}

- (void)setStatus:(YXTutorialControlStatus)status {
    _status = status;
    self.hidden = NO;
    _alertLabel.hidden = YES;
    _alertButton.hidden = YES;
    _playButton.hidden = NO;
    
    switch (_status) {
        case YXTutorialControlStatusUnknown: // 初始状态
            {
                
            }
            break;
        case YXTutorialControlStatusWAN: // 非WiFi
            {
                _alertLabel.hidden = NO;
                _alertButton.hidden = NO;
                _playButton.hidden = YES;
            }
            break;
        case YXTutorialControlStatusPlaying: // 播放中
            {
                [_playButton setImage:[UIImage imageNamed:@"tutorial_video_pause"] forState:UIControlStateNormal];
                [self hiddenWhenPlay];
            }
            break;
        case YXTutorialControlStatusPaused: // 暂停播放
            {
                [_playButton setImage:[UIImage imageNamed:@"tutorial_video_play"] forState:UIControlStateNormal];
            }
            break;
        case YXTutorialControlStatusEnded: // 播放结束
            {
                [_playButton setImage:[UIImage imageNamed:@"tutorial_video_replay"] forState:UIControlStateNormal];
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
    if (_status != YXTutorialControlStatusPlaying) {
        // 播放视频
        if (_availableMethods.playVideo) {
            [_delegate playVideo];
        }
        
        self.status = YXTutorialControlStatusPlaying;
    } else {
        // 暂停播放
        if (_availableMethods.pauseVideo) {
            [_delegate pauseVideo];
        }
        
        self.status = YXTutorialControlStatusPaused;
    }
}

// 非WiFi下播放
- (void)clickWANPlayAction:(UIButton *)sender {
    self.status = YXTutorialControlStatusPlaying;
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
    
    self.status = YXTutorialControlStatusPaused;
}

// 结束移动进度条
- (void)moveSliderAction:(UISlider *)sender {
    if (_availableMethods.moveSlider) {
        [_delegate moveSlider:sender.value];
    }
    
    self.status = YXTutorialControlStatusPlaying;
}

// 点击背景隐藏视图
- (void)hiddenControl {
    if (self.status == YXTutorialControlStatusPlaying) {
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
    
    if (self.hidden == NO && _status == YXTutorialControlStatusPlaying) {
        _timer = [ULTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(hiddenControl) userInfo:nil repeats:NO];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
