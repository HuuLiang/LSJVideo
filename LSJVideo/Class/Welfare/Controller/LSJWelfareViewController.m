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
DefineLazyPropertyInitialization(LSJWelfareModel, welfareModel)
DefineLazyPropertyInitialization(LSJColumnModel, response)

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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [self.welfareModel fetchWelfareInfoWithCompletionHandler:^(BOOL success, LSJColumnModel * obj) {
        if (success) {
            [_layoutTableView LSJ_endPullToRefresh];
            self.response = obj;
            [_layoutTableView reloadData];
        }
    }];
}

#pragma mark -  UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.response.programList.count;
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSJWelfareCell *welfareCell = [tableView dequeueReusableCellWithIdentifier:kWelfareCellReusableIdentifier forIndexPath:indexPath];
    
//    if (indexPath.row < self.response.programList.count) {
//        LSJProgramModel *program = self.response.programList[indexPath.row];
        welfareCell.timeStr = @"123123";
        welfareCell.countStr = @"23232";
        welfareCell.commandStr = @"2324";
    return welfareCell;
//    }
//    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == self.response.programList.count - 1) {
    if (indexPath.row == 9) {
        return kCellHeight - kWidth(20);
    } else {
        return kCellHeight;
    }
}



@end
