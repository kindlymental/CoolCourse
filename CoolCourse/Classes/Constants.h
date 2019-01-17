//
//  Constants.h
//  CoolCourse
//
//  Created by 刘怡兰 on 2019/1/10.
//  Copyright © 2019 lyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString * const httpPrefix;

#define RGB(r, g, b)    [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

#define CommonBlue RGB(65, 173, 241)
#define CommonThinBlue RGB(96, 212, 242)

#define WeakSelf  __weak __typeof(self) weakself = self;

#define ScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight   [[UIScreen mainScreen] bounds].size.height


#define XA_ADJUSTS_SCROLLVIEW_INSETS(scrollView)\
if (@available(iOS 11.0, *)) {\
if([scrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]){\
scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\
}\
} else {\
self.automaticallyAdjustsScrollViewInsets = NO;\
}

#define IS_IPHONE_SafeAreaBottomNotZero    isIPhoneXSeries()   // (SCREEN_MAX_LENGTH == 812.0)
#define IS_IPHONE_4 (SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5Less (SCREEN_MAX_LENGTH <= 568.0)
#define IS_IPHONE_5 (SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6Less (SCREEN_MAX_LENGTH <= 667.0)
#define IS_IPHONE_6P (SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_SafeAreaBottomNotZero    isIPhoneXSeries()   // (SCREEN_MAX_LENGTH == 812.0)
#define IS_IPHONE_X     (SCREEN_MAX_LENGTH == 812.0)

//导航栏的高度
#define UI_NAVIGATION_BAR_HEIGHT         44
//导航栏和状态栏的总高度
#define UI_NAVIGATION_BAR_and_StatusBar_HEIGHT (UI_STATUS_BAR_HEIGHT+UI_NAVIGATION_BAR_HEIGHT)
#define UI_STATUS_BAR_HEIGHT      (IS_IPHONE_SafeAreaBottomNotZero ? 44 : 20)
#define UI_TABBAR_IPHONE_X_HEIGHT  34

#define Font24px [UIFont systemFontOfSize:24.f]
#define Font22px [UIFont systemFontOfSize:22.f]
#define Font20px [UIFont systemFontOfSize:20.f]
#define Font18px [UIFont systemFontOfSize:18.f]
#define Font16px [UIFont systemFontOfSize:17.f]
#define Font17px [UIFont systemFontOfSize:16.f]
#define Font15px [UIFont systemFontOfSize:15.f]
#define Font14px [UIFont systemFontOfSize:14.f]
#define Font13px [UIFont systemFontOfSize:13.f]
#define Font12px [UIFont systemFontOfSize:12.f]
#define Font11px [UIFont systemFontOfSize:11.f]
#define Font10px [UIFont systemFontOfSize:10.f]
#define Font9px [UIFont systemFontOfSize:9.f]
#define Font8px [UIFont systemFontOfSize:8.f]
