//
//  VideoPlayView.h
//  CoolCourse
//
//  Created by 刘怡兰 on 2019/1/10.
//  Copyright © 2019 lyl. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 视频显示
 */
@interface VideoPlayView : UIView

/**
 显示教学视频弹窗（自动判断是否从没显示过）
 
 @param block 点击播放
 @param cancelBlock 取消
 */
+ (void)showWithPlayBlock:(nullable void (^)(void))block
              cancelBlock:(nullable void (^)(void))cancelBlock;

@end
