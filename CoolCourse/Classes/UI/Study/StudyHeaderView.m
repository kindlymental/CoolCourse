//
//  StudyHeaderView.m
//  CoolCourse
//
//  Created by 刘怡兰 on 2019/1/10.
//  Copyright © 2019 lyl. All rights reserved.
//

#import "StudyHeaderView.h"
#import "JYWaveView.h"

@interface StudyHeaderView ()

/** 个人信息视图 */
@property (weak, nonatomic) IBOutlet UIView *infoView;

/** 头像 */
@property (weak, nonatomic) IBOutlet UIButton *iconImgBtn;

// 课程选择按钮
@property (weak, nonatomic) IBOutlet UIButton *courseType_first;

// 波浪
@property (nonatomic,strong) JYWaveView *waveView;

// banner的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

@end

@implementation StudyHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];

        self.infoView.backgroundColor = CommonBlue;
        
        // 添加波浪动画效果
        [self addSubview:self.waveView];
        
        self.iconImgBtn.backgroundColor = UIColor.whiteColor;
        self.iconImgBtn.layer.masksToBounds = YES;
        self.iconImgBtn.layer.cornerRadius = self.iconImgBtn.mj_h * 0.5;
    }
    return self;
}

- (IBAction)closeBottomViewAction:(id)sender {
    
    self.bottomViewHeight.constant = 0;
    [self layoutIfNeeded];
    
    if (self.closeBlock) {
        self.closeBlock();
    }
}

#pragma mark - 懒加载

- (JYWaveView *)waveView {
    if (!_waveView) {
        _waveView = [[JYWaveView alloc] initWithFrame:CGRectMake(0, self.bottomView.mj_y - 10, ScreenWidth, 10)];
        _waveView.frontColor = [UIColor whiteColor];
        _waveView.insideColor = CommonThinBlue;
        _waveView.directionType = WaveDirectionTypeBackWard;
        _waveView.frontSpeed = 0.02;
        _waveView.insideSpeed = 0.02;
    }
    return _waveView;
}

@end
