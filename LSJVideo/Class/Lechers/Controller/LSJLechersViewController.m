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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _layoutTableView = [[UITableView alloc] init];
    [_layoutTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    [_layoutTableView registerClass:[LSJLechersListCell class] forCellReuseIdentifier:kLechersListCellReusableIdentifier];
    
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
    LSJLechersListCell *cell = [tableView dequeueReusableCellWithIdentifier:kLechersListCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < _dataSource.count) {
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
