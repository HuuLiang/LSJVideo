//
//  LSJWelfareViewController.m
//  LSJVideo
//
//  Created by Liang on 16/8/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJWelfareViewController.h"
#import "LSJWelfareModel.h"
#import "LSJWelfareCell.h"
#import "LSJDetailVideoVC.h"

//#define kCellHeight (kScreenWidth - 2 *kWidth(20))/3 * 9 / 7 + kWidth(160)

static NSString *const kWelfareCellReusableIdentifier = @"WelfareCellReusableIdentifier";

@interface LSJWelfareViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
}
@property (nonatomic) LSJWelfareModel *welfareModel;
@property (nonatomic) LSJColumnModel *response;
@end

@implementation LSJWelfareViewController
QBDefineLazyPropertyInitialization(LSJWelfareModel, welfareModel)
QBDefineLazyPropertyInitialization(LSJColumnModel, response)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [_layoutTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    [_layoutTableView registerClass:[LSJWelfareCell class] forCellReuseIdentifier:kWelfareCellReusableIdentifier];
    
    
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [_layoutTableView LSJ_addPullToRefreshWithHandler:^{
        [self loadData];
    }];
    
    [_layoutTableView LSJ_triggerPullToRefresh];
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.response.programList.count == 0) {
            [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
                @strongify(self);
                [self->_layoutTableView LSJ_triggerPullToRefresh];
            }];
        }
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    @weakify(self);
    [self.welfareModel fetchWelfareInfoWithCompletionHandler:^(BOOL success, LSJColumnModel * obj) {
        @strongify(self);
        [_layoutTableView LSJ_endPullToRefresh];
        [self removeCurrentRefreshBtn];
        if (success) {
            self.response = obj;
            [_layoutTableView reloadData];
        }else {
            if (self.response.programList.count == 0) {
                [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
                    @strongify(self);
                    [self->_layoutTableView LSJ_triggerPullToRefresh];
                }];
            }
        }
    }];
}

#pragma mark -  UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.response.programList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSJWelfareCell *welfareCell = [tableView dequeueReusableCellWithIdentifier:kWelfareCellReusableIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < self.response.programList.count) {
        LSJProgramModel *program = self.response.programList[indexPath.row];
        welfareCell.titleStr = program.title;
        welfareCell.timeStr = program.spare;
        welfareCell.commandStr = program.specialDesc;
        welfareCell.imgAUrlStr = program.imgurls[0];
        welfareCell.imgBUrlStr = program.imgurls[1];
        welfareCell.imgCUrlStr = program.imgurls[2];
        return welfareCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.response.programList.count - 1) {
        return kCellHeight - kWidth(20);
    } else {
        return kCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.response.programList.count) {
        LSJProgramModel *program = self.response.programList[indexPath.row];
        LSJBaseModel *baseModle = [LSJBaseModel createModelWithProgramId:@(program.programId) ProgramType:@(program.type) RealColumnId:@(self.response.realColumnId) ChannelType:@(self.response.type) PrgramLocation:indexPath.item Spec:NSNotFound subTab:NSNotFound];
        [self pushToDetailVideoWithController:self ColumnId:self.response.columnId program:program baseModel:baseModle];
        [[LSJStatsManager sharedManager] statsCPCWithBaseModel:baseModle andTabIndex:self.tabBarController.selectedIndex subTabIndex:[LSJUtil currentSubTabPageIndex]];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[LSJStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[LSJUtil currentSubTabPageIndex] forSlideCount:1];
}


@end
