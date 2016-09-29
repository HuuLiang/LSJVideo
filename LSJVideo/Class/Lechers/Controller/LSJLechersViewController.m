//
//  LSJLechersViewController.m
//  LSJVideo
//
//  Created by Liang on 16/8/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJLechersViewController.h"
#import "LSJLecherModel.h"
#import "LSJLechersListCell.h"
#import "LSJLechersListVC.h"

static  NSString *const kLechersListCellReusableIdentifier = @"kLechersListCellReuseableIdentifier";

@interface LSJLechersViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
}
@property (nonatomic) LSJLecherModel *lecherModel;
@property (nonatomic) NSMutableArray *dataSource;
@end

@implementation LSJLechersViewController
QBDefineLazyPropertyInitialization(LSJLecherModel, lecherModel)
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _layoutTableView = [[UITableView alloc] init];
    [_layoutTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    [_layoutTableView registerClass:[LSJLechersListCell class] forCellReuseIdentifier:kLechersListCellReusableIdentifier];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [self.lecherModel fetchLechersInfoWithCompletionHandler:^(BOOL success, id obj) {
        if (success) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:obj];
            [_layoutTableView reloadData];
            [_layoutTableView LSJ_endPullToRefresh];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    LSJLechersListCell *cell = [tableView dequeueReusableCellWithIdentifier:kLechersListCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < _dataSource.count) {
        LSJLecherColumnsModel *column = _dataSource[indexPath.row];
        cell.titleStr = column.name;
        cell.dataArr = column.columnList;
        cell.action = ^(NSNumber *index) {
            @strongify(self);
//            if (![LSJUtil isSVip]) {
//                LSJBaseModel *baseModel = [LSJBaseModel createModelWithProgramId:nil ProgramType:nil RealColumnId:@(column.realColumnId) ChannelType:@(column.type) PrgramLocation:indexPath.item Spec:NSNotFound subTab:NSNotFound];
//                [self payWithBaseModelInfo:baseModel];
//            }
            LSJLechersListVC *listVC = [[LSJLechersListVC alloc] initWithColumn:column andIndex:[index integerValue]];
            [self.navigationController pushViewController:listVC animated:YES];
            
            LSJBaseModel *baseModel = [LSJBaseModel createModelWithProgramId:nil ProgramType:nil RealColumnId:@(column.realColumnId) ChannelType:@(column.type) PrgramLocation:indexPath.row Spec:NSNotFound subTab:index.integerValue];
            [[LSJStatsManager sharedManager] statsCPCWithBaseModel:baseModel inTabIndex:self.tabBarController.selectedIndex];
        };
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 9) {
        return kCellHeight - kWidth(20);
    } else {
        return kCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[LSJStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:[LSJUtil currentSubTabPageIndex] forSlideCount:1];
}

@end
