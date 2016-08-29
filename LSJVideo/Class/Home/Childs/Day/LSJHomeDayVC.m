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
@property (nonatomic)LSJColumnConfigModel *columnModel;
@property (nonatomic)NSMutableArray *dataSource;
@end

@implementation LSJHomeDayVC
DefineLazyPropertyInitialization(LSJColumnConfigModel, columnModel)
DefineLazyPropertyInitialization(NSMutableArray, dataSource)

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
    [self.columnModel fetchColumnsInfoWithColumnId:_columnId IsProgram:YES CompletionHandler:^(BOOL success, id obj) {
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
//    return _dataSource.count;
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSJDayCell *cell = [tableView dequeueReusableCellWithIdentifier:kDayCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < 10) {

        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    LSJDayCell * dayCell = (LSJDayCell *)cell;
    if (indexPath.row < 10) {
        dayCell.imgUrlStr = @"http://apkcdn.mquba.com/wysy/tuji/img_pic/20151112labc.jpg";
        dayCell.titleStr = @"混血空姐与富二代男友久别激情";
        dayCell.contactCount = 569;
        dayCell.userContacts = @[@"11111",@"22222",@"33333",@"44444",@"55555",@"66666",@"77777",@"88888",@"11111",@"22222",@"33333"];
        dayCell.start = YES;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    LSJDayCell *dayCell = (LSJDayCell *)cell;
    if (indexPath.row < 10) {
        dayCell.start = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 10) {
        return kScreenWidth * 14 / 15 - kWidth(20);
    } else {
        return kScreenWidth * 14 / 15;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
