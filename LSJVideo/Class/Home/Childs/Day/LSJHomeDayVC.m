//
//  LSJHomeDayVC.m
//  LSJVideo
//
//  Created by Liang on 16/8/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJHomeDayVC.h"
#import "LSJColumnConfigModel.h"
#import "LSJDayCell.h"

static NSString *const kDayCellReusableIdentifier = @"kDayCellReusableIdentifier";

@interface LSJHomeDayVC () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _columnId;
    UITableView *_layoutTableView;
}
@property (nonatomic) LSJColumnDayModel * columnModel;
@property (nonatomic) LSJColumnModel * response;
@end

@implementation LSJHomeDayVC
QBDefineLazyPropertyInitialization(LSJColumnDayModel, columnModel)
QBDefineLazyPropertyInitialization(LSJColumnModel, response)

- (instancetype)initWithColumnId:(NSInteger)columnId
{
    self = [super init];
    if (self) {
        _columnId = columnId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _layoutTableView = [[UITableView alloc] init];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    [_layoutTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [_layoutTableView registerClass:[LSJDayCell class] forCellReuseIdentifier:kDayCellReusableIdentifier];
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
    [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
        @strongify(self);
        [self->_layoutTableView LSJ_endPullToRefresh];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self->_layoutTableView LSJ_triggerPullToRefresh];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    @weakify(self);
    [self.columnModel fetchDayInfoWithColumnId:_columnId CompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        [self removeCurrentRefreshBtn];
        [_layoutTableView LSJ_endPullToRefresh];
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

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.response.programList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSJDayCell *cell = [tableView dequeueReusableCellWithIdentifier:kDayCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.response.programList.count) {
        LSJProgramModel *program = self.response.programList[indexPath.row];
        cell.imgUrlStr = program.coverImg;
        cell.titleStr = program.title;
        cell.contact = program.spare;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    LSJDayCell * dayCell = (LSJDayCell *)cell;
    if (indexPath.row < self.response.programList.count) {
        LSJProgramModel *program = self.response.programList[indexPath.row];
        dayCell.userComments = program.comments;
        dayCell.start = YES;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    LSJDayCell *dayCell = (LSJDayCell *)cell;
    if (indexPath.row < self.response.programList.count) {
        dayCell.start = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.response.programList.count - 1) {
        return kScreenWidth * 14 / 15 - kWidth(20);
    } else {
        return kScreenWidth * 14 / 15;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.response.programList.count) {
        LSJProgramModel *program = self.response.programList[indexPath.row];
        LSJBaseModel *baseModel = [LSJBaseModel createModelWithProgramId:@(program.programId) ProgramType:@(program.type) RealColumnId:@(self.response.realColumnId) ChannelType:@(self.response.type) PrgramLocation:indexPath.row Spec:NSNotFound subTab:0];
        [self playVideoWithUrl:program.videoUrl baseModel:baseModel];
        [[LSJStatsManager sharedManager] statsCPCWithBaseModel:baseModel andTabIndex:self.tabBarController.selectedIndex subTabIndex:0];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[LSJStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:0 forSlideCount:1];
}
@end
