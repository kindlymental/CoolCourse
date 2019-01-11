//
//  ULTimer.h
//  UlifeFoundation
//
//  Created by mac on 2018/11/14.
//  Copyright © 2018年 xmulife. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 自动释放定时器：功能同NSTimer相应方法
 */
@interface ULTimer : NSObject

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                     target:(id)aTarget
                                   selector:(SEL)aSelector
                                   userInfo:(nullable id)userInfo
                                    repeats:(BOOL)yesOrNo;

@end
