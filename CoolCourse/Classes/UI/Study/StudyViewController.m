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

@interface StudyViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) StudyHeaderView *headerView;

// banner数据
@property (nonatomic,strong) NSMutableArray<BannerModel *> *bannerArray;

@end

static NSString *CellID = @"VideoPlayViewCell";

@implementation StudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadUI];
    
    [self loadData];
}

- (void)loadUI {
    
    [self.view addSubview:self.tableView];

    self.headerView.mj_h = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.tableView.tableHeaderView = self.headerView;
}

- (void)loadData {
    
    NSString *jsonStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"user" ofType:@"json"] encoding:0 error:nil];
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"%@",jsonDic);
    
    NSArray *slideDic = [[jsonDic objectForKey:@"res"] objectForKey:@"slide"];
    
    self.bannerArray = [NSMutableArray array];
    for (NSDictionary *dic in slideDic) {
        [self.bannerArray addObject:[BannerModel yy_modelWithJSON:dic]];
    }
    
    // 刷新banner
    self.headerView.bottomView.bannerDataArray = self.bannerArray.copy;
}

#pragma mark - 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    VideoPlayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[VideoPlayViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    return cell;
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"VideoPlayViewCell" bundle:nil] forCellReuseIdentifier:CellID];
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
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
