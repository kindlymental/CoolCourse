//
//  WaveView.m
//  WaveView
//
//  Created by iOS on 16/6/20.
//  Copyright © 2016年 iOS. All rights reserved.
//

#import "WaveView.h"

@interface WaveView ()

@property (nonatomic,strong) NSTimer * timer;

@property (nonatomic,assign) CGRect myFrame;

@property (nonatomic,assign) CGFloat fa;

@property (nonatomic,assign) CGFloat bigNumber;

@end
@implementation WaveView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _myFrame = frame;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)createTimer{
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(action) userInfo:nil repeats:YES];
    }
    [self.timer setFireDate:[NSDate distantPast]];
}
- (void)action {
    // 让波浪移动效果
    _fa = _fa+3;
    if (_fa >= _myFrame.size.width * 2.0) {
        _fa = 0;
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    [self drawLineWithRect:rect index:1];
    [self drawLineWithRect:rect index:2];
}

- (void)drawLineWithRect:(CGRect)rect index:(int)index {
    
    float y = (1 - self.present) * rect.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 创建路径
    CGMutablePathRef path = CGPathCreateMutable();
    
    // 画水
    CGContextSetLineWidth(context, 1);
    UIColor *color;
    if (index == 1) {
        color = CommonBlue;
    } else {
        color = [UIColor whiteColor];
    }
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGPathMoveToPoint(path, NULL, 0, y);
    for(float x=0; x<=rect.size.width; x++) {
        //正弦函数
        y = sin(x/rect.size.width * M_PI + _fa/rect.size.width * M_PI + ((index == 1) ? 0 : M_PI)) *_bigNumber + (1 - self.present) * rect.size.height;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, (index == 1 ? rect.size.width : rect.size.height), (index == 1 ? rect.size.height : rect.size.width));
    CGPathAddLineToPoint(path, nil, 0, rect.size.height);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
}

- (void)setPresent:(CGFloat)present{
    _present = present;
    // 启动定时器
    [self createTimer];
    // 修改波浪的幅度
    if (present <= 0.5) {
        _bigNumber = _myFrame.size.height * 0.1 * present * 2;
    }else{
        _bigNumber = _myFrame.size.height * 0.1 * (1 - present) * 2;
    }
}
@end
