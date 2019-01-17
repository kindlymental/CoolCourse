//
//  StudyHeaderView.h
//  CoolCourse
//
//  Created by 刘怡兰 on 2019/1/10.
//  Copyright © 2019 lyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyHeaderBottomView.h"

typedef void(^StudyHeaderViewCloseBannerViewBlock)(void);

@interface StudyHeaderView : UIView

@property (nonatomic,copy) StudyHeaderViewCloseBannerViewBlock closeBlock;

@property (weak, nonatomic) IBOutlet StudyHeaderBottomView *bottomView;

@end

