//
//  ULTimer.m
//  UlifeFoundation
//
//  Created by mac on 2018/11/14.
//  Copyright © 2018年 xmulife. All rights reserved.
//

#import "ULTimer.h"

@interface ULTimerTarget : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation ULTimerTarget

- (void)fire:(NSTimer *)timer {
    if (self.target) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:timer.userInfo];
#pragma clang diagnostic pop
    } else {
        [self.timer invalidate];
    }
}

@end

@implementation ULTimer

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                     target:(id)aTarget
                                   selector:(SEL)aSelector
                                   userInfo:(nullable id)userInfo
                                    repeats:(BOOL)yesOrNo {
    ULTimerTarget *timerTarget = [[ULTimerTarget alloc] init];
    timerTarget.target = aTarget;
    timerTarget.selector = aSelector;
    timerTarget.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:timerTarget selector:@selector(fire:) userInfo:userInfo repeats:yesOrNo];
    
    return timerTarget.timer;
}

@end
