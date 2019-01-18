//
//  StudyViewController.m
//  CoolCourse
//
//  Created by 刘怡兰 on 2019/1/10.
//  Copyright © 2019 lyl. All rights reserved.
//

#import "StudyViewController.h"
#import "VideoPlayViewCell.h"
#import "StudyHeaderView.h"
#import "BannerModel.h"
#import "StudyHeaderBottomView.h"
#import "XANavBarTransition.h"
#import "CourseModel.h"
#import "StudyVideoPlayViewController.h"
#import "VideoStreamViewController.h"

@interface StudyViewController () <UITableViewDelegate,UITableViewDataSource,XATransitionDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) StudyHeaderView *headerView;

// banner数据
@property (nonatomic,strong) NSMutableArray<BannerModel *> *bannerArray;
// 视频数据
@property (nonatomic,strong) NSMutableArray<CourseModel *> *videoArray;

@end

static NSString *CellID = @"VideoPlayViewCell";

@implementation StudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNav];
    
    [self loadUI];
    
    [self loadData];
}

/**
  导航栏平滑透明度渐变
 */
- (void)setupNav {
    XA_ADJUSTS_SCROLLVIEW_INSETS(self.tableView);
    
    self.title = @"学习";
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.xa_navBarAlpha = 0;
    self.xa_transitionMode = XATransitionModeLeft;
    self.xa_transitionDelegate = self;
}

- (void)loadUI {
    
    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
//            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//        } else {
//            // Fallback on earlier versions
//        }
//        if (@available(iOS 11.0, *)) {
//            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
//        } else {
//            // Fallback on earlier versions
//        }
//    }];

    self.headerView.mj_h = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.tableView.tableHeaderView = self.headerView;
}

- (void)loadData {
    
    NSString *jsonStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"user" ofType:@"json"] encoding:0 error:nil];
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"%@",jsonDic);
    
    NSArray *slideDic = [[jsonDic objectForKey:@"res"] objectForKey:@"slide"];
    NSArray *freecourse = [[jsonDic objectForKey:@"res"] objectForKey:@"freecourse"];
    
    self.bannerArray = [NSMutableArray array];
    for (NSDictionary *dic in slideDic) {
        [self.bannerArray addObject:[BannerModel yy_modelWithJSON:dic]];
    }
    
    // 刷新banner
    self.headerView.bottomView.bannerDataArray = self.bannerArray.copy;
    
    // 刷新视频
    self.videoArray = [NSMutableArray array];
    for (NSDictionary *videoDic in freecourse) {
        [self.videoArray addObject:[CourseModel yy_modelWithJSON:videoDic]];
    }
    [self.tableView reloadData];
}

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY > 0){
        self.xa_navBarAlpha = (offsetY - 50 ) / 150;
        [self.navigationController xa_changeNavBarAlpha:self.xa_navBarAlpha];
    }
}

#pragma mark - XATransitionDelegate

- (UIViewController *)xa_nextViewControllerInTransitionMode:(XATransitionMode)transitionMode{
    UIViewController *vc = [[UIViewController alloc]init];
    return vc;
}

#pragma mark - UITableView代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    VideoPlayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[VideoPlayViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    cell.model = self.videoArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        StudyVideoPlayViewController *videoVc = [[StudyVideoPlayViewController alloc]init];
        //    videoVc.videoUrl = self.videoArray[indexPath.row].burl;
        videoVc.videoUrl = @"http://flv3.bn.netease.com/videolib3/1707/03/bGYNX4211/SD/bGYNX4211-mobile.mp4";
        self.hidesBottomBarWhenPushed = YES;
        [self presentViewController:videoVc animated:YES completion:nil];
        self.hidesBottomBarWhenPushed=NO;
    } else {
        VideoStreamViewController *vc = [[VideoStreamViewController alloc]init];
        //    vc.videoUrl = self.videoArray[indexPath.row].burl;
        vc.videoUrl = @"http://flv.bn.netease.com/videolib3/1707/03/bGYNX4211/SD/movie_index.m3u8";
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - 视图出现和消失的时候调用,对banner的轮播进行控制

- (void)startTimer {
    [self.headerView.bottomView startTimer];
}

- (void)pauseTimer{
    [self.headerView.bottomView pauseTimer];
}

#pragma mark - 懒加载

- (UITableView *)tableView {
    if (!_tableView) {
        // 设置tableHeaderView时，防止出现问题，都使用frame设置
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - UI_NAVIGATION_BAR_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"VideoPlayViewCell" bundle:nil] forCellReuseIdentifier:CellID];
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (StudyHeaderView *)headerView {
    if (!_headerView) {
        WeakSelf
        _headerView = [[StudyHeaderView alloc]initWithFrame:CGRectZero];
        _headerView.closeBlock = ^{
            weakself.headerView.mj_h = [weakself.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            [weakself.tableView beginUpdates];
            [weakself.tableView setTableHeaderView:weakself.headerView];
            [weakself.tableView endUpdates];
        };
    }
    return _headerView;
}

@end
