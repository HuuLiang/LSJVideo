//
//  LSJHomeAppVC.m
//  LSJVideo
//
//  Created by Liang on 16/8/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJHomeAppVC.h"
#import "LSJAppCell.h"
#import "LSJHomeProgramModel.h"
#import <SDCycleScrollView.h>

static NSString *const kAppCellReusableIdentifier = @"AppCellReusableIdentifier";
static NSString *const kBannerCellReusableIdentifier = @"BannerCellReusableIdentifier";

@interface LSJHomeAppVC () <SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
    UITableViewCell *_bannerCell;
    SDCycleScrollView *_bannerView;
}
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) LSJHomeProgramModel *programModel;
@end

@implementation LSJHomeAppVC
DefineLazyPropertyInitialization(NSMutableArray, dataSource)
DefineLazyPropertyInitialization(LSJHomeProgramModel, programModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    _bannerView = [[SDCycleScrollView alloc] init];
    _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _bannerView.autoScrollTimeInterval = 3;
    _bannerView.titleLabelBackgroundColor = [UIColor clearColor];
    _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _bannerView.delegate = self;
    _bannerView.backgroundColor = [UIColor whiteColor];
    
    
    UICollectionViewFlowLayout *mainLayout = [[UICollectionViewFlowLayout alloc] init];
    mainLayout.minimumLineSpacing = 5;
    mainLayout.minimumInteritemSpacing = 5;
    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    [_layoutTableView registerClass:[LSJAppCell class] forCellReuseIdentifier:kAppCellReusableIdentifier];
    [_layoutTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kBannerCellReusableIdentifier];
    
    
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

- (void)loadData {
    [self.programModel fetchHomeInfoWithColumnId:0 IsProgram:YES CompletionHandler:^(BOOL success, id obj) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -  UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return _dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (!_bannerCell) {
            _bannerCell = [tableView dequeueReusableCellWithIdentifier:kBannerCellReusableIdentifier forIndexPath:indexPath];
            [_bannerCell.contentView addSubview:_bannerView];
            {
                [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(_bannerCell);
                }];
            }
        }
        return _bannerCell;
    } else {
        LSJAppCell *appCell = [tableView dequeueReusableCellWithIdentifier:kAppCellReusableIdentifier forIndexPath:indexPath];
        
        return appCell;
    }

    
    
}


@end
