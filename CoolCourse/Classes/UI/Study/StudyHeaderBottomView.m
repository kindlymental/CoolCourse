//
//  StudyHeaderBottomView.m
//  CoolCourse
//
//  Created by 刘怡兰 on 2019/1/11.
//  Copyright © 2019 lyl. All rights reserved.
//

#import "StudyHeaderBottomView.h"
#import "BannerView.h"
#import "BannerModel.h"

@interface StudyHeaderBottomView ()

// Banner
@property (nonatomic,strong) BannerView *bannerView;

@end

@implementation StudyHeaderBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    
    [self addSubview:self.bannerView];
    
    // 超出父视图不显示
    self.clipsToBounds = YES;
}

- (void)setBannerDataArray:(NSArray *)bannerDataArray {
    
    _bannerDataArray = bannerDataArray;
    
    NSMutableArray *urls = [NSMutableArray array];
    NSMutableArray *webUrls = [NSMutableArray array];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (BannerModel *model in bannerDataArray) {
            [urls addObject:[NSURL URLWithString:model.pic]];
            [webUrls addObject:[NSURL URLWithString:model.url]];
        }
        
        self.bannerView.urls = urls;
        self.bannerView.webUrls = webUrls;
    });
}

- (void)startTimer {
    [self.bannerView startTimer];
}

- (void)pauseTimer {
    [self.bannerView pauseTimer];
}

#pragma mark - 懒加载

- (BannerView *)bannerView {
    if (!_bannerView) {
        
        _bannerView = [[BannerView alloc]initBannerViewWithFrame:CGRectMake(30, 25, ScreenWidth - 30*2, self.mj_h - 25*2) imageUrls:nil webUrls:nil timerInterval:4 noDataImage:@"my_center_topBanner" didSelect:^(NSUInteger Index) {
            if ((Index - 1) >= 0 && (Index - 1) < self->_bannerView.webUrls.count) {
                NSLog(@"%@",self->_bannerView.webUrls[Index-1]);
            }
        }];
        
        _bannerView.layer.masksToBounds = YES;
        _bannerView.layer.cornerRadius = _bannerView.mj_h * 0.5;
    }
    return _bannerView;
}

@end
