//
//  VideoStreamViewController.m
//  CoolCourse
//
//  Created by 刘怡兰 on 2019/1/13.
//  Copyright © 2019 lyl. All rights reserved.
//

#import "VideoStreamViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface VideoStreamViewController ()

@property (nonatomic, strong) IJKFFMoviePlayerController * ijkPlayer;

@end

@implementation VideoStreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置控制器的view大小
    self.ijkPlayer.view.frame = self.view.frame;
    // 控制器的view添加到自身的view上面
    [self.view addSubview:self.ijkPlayer.view];
    
    [self navSetting];
}

- (void)navSetting {
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:@"tutorial_video_close"] forState:UIControlStateNormal];
    back.frame = CGRectMake(20, 44, 40, 40);
    [self.ijkPlayer.view addSubview:back];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.ijkPlayer.isPlaying) {
        //播放
        [self.ijkPlayer prepareToPlay];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.ijkPlayer.isPlaying) {
        //关闭
        [self.ijkPlayer shutdown];
    }
}

- (void)backAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 懒加载

- (IJKFFMoviePlayerController *)ijkPlayer {
    if (!_ijkPlayer) {
        _ijkPlayer = [[IJKFFMoviePlayerController alloc] initWithContentURLString:self.videoUrl withOptions:nil];
        //设置打印级别, 测试发现没有什么效果
        [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
        [_ijkPlayer setScalingMode:IJKMPMovieScalingModeAspectFill];
    }
    return _ijkPlayer;
}

@end
