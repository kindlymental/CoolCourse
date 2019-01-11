//
//  TabBarViewController.m
//  CoolCourse
//
//  Created by 刘怡兰 on 2019/1/10.
//  Copyright © 2019 lyl. All rights reserved.
//

#import "TabBarViewController.h"
#import "NavigationViewController.h"
#import "StudyViewController.h"
#import "DiscoverViewController.h"
#import "MineViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addChildVc];
}

- (void)addChildVc {
    
    NSMutableArray *vcArray = [NSMutableArray arrayWithCapacity:3];
    StudyViewController *studyVc = [[StudyViewController alloc]init];
    studyVc.tabBarItem.title = @"学习";
    DiscoverViewController *discoverVc = [[DiscoverViewController alloc]init];
    discoverVc.tabBarItem.title = @"发现";
    MineViewController *mineVc = [[MineViewController alloc]init];
    mineVc.tabBarItem.title = @"我的";
    [vcArray addObject:studyVc];
    [vcArray addObject:discoverVc];
    [vcArray addObject:mineVc];
    
    for (int i=1; i<=vcArray.count; i++) {
        UIViewController *vc = vcArray[i-1];
        NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:vc];
        vc.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"tab_%d",i]];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"tab_%d",i]];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.image = image;
        UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tab_%d_selected",i]];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = selectedImage;
        [self addChildViewController:nav];
    }
}

@end
