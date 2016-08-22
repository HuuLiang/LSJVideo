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
DefineLazyPropertyInitialization(LSJLecherModel, lecherModel)
DefineLazyPropertyInitialization(NSMutableArray, dataSource)

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
            [_layoutTableView LSJ_endPullToRefresh];
            [self.dataSource addObjectsFromArray:obj];
            [_layoutTableView reloadData];
        }
    }];
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
            LSJLechersListVC *listVC = [[LSJLechersListVC alloc] initWithColumn:column andIndex:[index integerValue]];
            [self.navigationController pushViewController:listVC animated:YES];
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

@end
