//
//  BannerView.h
//
//  Created by U on 2018/12/7.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectBannerItemBlock)(NSUInteger Index);

@interface BannerView : UIView

// url集合
@property (copy, nonatomic) NSArray<NSURL *> *urls;
// 点击跳转的web集合
@property (copy, nonatomic) NSArray<NSURL *> *webUrls;

- (instancetype)initBannerViewWithFrame:(CGRect)frame imageUrls:(NSArray *)imageUrls webUrls:(NSArray *)webUrls timerInterval:(NSTimeInterval)timerInterval noDataImage:(NSString *)imageName didSelect:(DidSelectBannerItemBlock)didSelect;

- (void)startTimer;

- (void)pauseTimer;

/** 初始化 */
/**
- (BannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[BannerView alloc]initBannerViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight * 0.18) imageUrls:nil webUrls:nil timerInterval:4 noDataImage:@"misc_battery_power_ico" didSelect:^(NSUInteger Index) {
            if ((Index - 1) >= 0 && (Index - 1) < self->_bannerView.webUrls.count) {
                NSLog(@"%@",self->_bannerView.webUrls[Index-1]);
            }
        }];
    }
    return _bannerView;
}
 
 dispatch_async(dispatch_get_main_queue(), ^{
 self.bannerView.urls = urlArr.copy;
 self.bannerView.webUrls = webArr.copy;
 });
 
 */

@end
