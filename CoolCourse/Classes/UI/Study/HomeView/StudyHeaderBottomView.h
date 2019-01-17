//
//  StudyHeaderBottomView.h
//  CoolCourse
//
//  Created by 刘怡兰 on 2019/1/11.
//  Copyright © 2019 lyl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudyHeaderBottomView : UIView

@property (nonatomic,strong) NSArray *bannerDataArray;

- (void)startTimer;

- (void)pauseTimer;

@end

