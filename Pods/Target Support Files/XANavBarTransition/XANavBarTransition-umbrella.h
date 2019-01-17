#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "XABaseTransitionAnimation.h"
#import "XALeftTransitionAnimation.h"
#import "XARightTransitionAnimation.h"
#import "UIView+XATransitionExtension.h"
#import "XANavigationControllerObserver.h"
#import "XABaseTransition.h"
#import "XALeftTransition.h"
#import "XARightTransition.h"
#import "XATransitionFactory.h"
#import "XATransitionSession.h"
#import "UINavigationController+XANavBarTransition.h"
#import "UIViewController+XANavBarTransition.h"
#import "XANavBarTransition.h"
#import "XANavBarTransitionConst.h"
#import "XANavBarTransitionTool.h"

FOUNDATION_EXPORT double XANavBarTransitionVersionNumber;
FOUNDATION_EXPORT const unsigned char XANavBarTransitionVersionString[];

