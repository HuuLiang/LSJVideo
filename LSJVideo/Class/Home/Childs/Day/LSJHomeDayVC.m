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
@property (nonatomic)NSMutableArray *dataSource;
@end

@implementation LSJHomeDayVC
QBDefineLazyPropertyInitialization(LSJColumnDayModel, columnModel)
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    @weakify(self);
    [self.columnModel fetchDayInfoWithColumnId:_columnId CompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (success) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:obj];
            [_layoutTableView reloadData];
            [_layoutTableView LSJ_endPullToRefresh];
        }
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSJDayCell *cell = [tableView dequeueReusableCellWithIdentifier:kDayCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < _dataSource.count) {
        LSJProgramModel *program = _dataSource[indexPath.row];
        cell.imgUrlStr = program.coverImg;
        cell.titleStr = program.title;
        cell.contact = program.spare;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    LSJDayCell * dayCell = (LSJDayCell *)cell;
    if (indexPath.row < _dataSource.count) {
        LSJProgramModel *program = _dataSource[indexPath.row];
        dayCell.userComments = program.comments;
        dayCell.start = YES;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    LSJDayCell *dayCell = (LSJDayCell *)cell;
    if (indexPath.row < _dataSource.count) {
        dayCell.start = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _dataSource.count - 1) {
        return kScreenWidth * 14 / 15 - kWidth(20);
    } else {
        return kScreenWidth * 14 / 15;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
