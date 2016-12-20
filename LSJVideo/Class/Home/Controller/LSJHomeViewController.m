//
//  LSJHomeViewController.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJHomeViewController.h"

#import "LSJHomeModel.h"

#import "LSJHomeDayVC.h"
#import "LSJHomeRecommdVC.h"
#import "LSJHomeCategoryVC.h"
#import "LSJHomeRankVC.h"
#import "LSJHomeAppVC.h"

#import "SDCursorView.h"
#import "LSJVersionUpdateViewController.h"
#import "LSJVersionUpdateModel.h"

@interface LSJHomeViewController ()<SDCursorViewDelegate>
{
    SDCursorView *_cursorView;
}
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) LSJHomeModel *homeModel;
@end

@implementation LSJHomeViewController
QBDefineLazyPropertyInitialization(LSJHomeModel, homeModel)
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (void)viewDidLoad {
    [super viewDidLoad];
    [self examineUpdate];//检查更新
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#efefef"] colorWithAlphaComponent:0.99];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = [UIColor colorWithHexString:@"#ffe100"];
    [self.view addSubview:view];
    

    [self loadModel];
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.dataSource.count == 0) {
            [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
                @strongify(self);
                [self loadModel];
            }];
        }
    });
}

- (void)examineUpdate {
    [[LSJVersionUpdateModel sharedModel] fetchLatestVersionWithCompletionHandler:^(BOOL success, id obj) {
        if (success) {
            LSJVersionUpdateInfo *info = obj;
            if (info.up.boolValue) {
                LSJVersionUpdateViewController *updateVC = [[LSJVersionUpdateViewController alloc] init];
                updateVC.linkUrl = info.linkUrl;
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:updateVC animated:YES completion:nil];
            }
        }
    }];
}

- (void)loadModel {
    @weakify(self);
    [self.homeModel fetchHomeInfoWithCompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
       
        if (success) {
            self.dataSource = [NSMutableArray arrayWithArray:obj];
             [self removeCurrentRefreshBtn];
            [self create];
        }
//        else {
//            if (self.dataSource.count == 0) {
//                [self addRefreshBtnWithCurrentView:self.view withAction:^(id obj) {
//                    @strongify(self);
//                    [self loadModel];
//                }];
//            }
//        }
    }];
}

- (void)create {
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (LSJHomeColumnsModel *columnModel in _dataSource) {
        [titles addObject:columnModel.name];
    }
    
    _cursorView = [[SDCursorView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    _cursorView.isHomeView = YES;
    _cursorView.delegate = self;
    //设置子页面容器的高度
    _cursorView.contentViewHeight = kScreenHeight - 44 - 49 - 20;
    _cursorView.cursorEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    //设置控件所在controller
    _cursorView.parentViewController = self;
    _cursorView.titles = titles;
    
    //设置所有子controller
    NSMutableArray *contrors = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 4; i++) {
        LSJHomeColumnsModel *columnModel = _dataSource[i];
        if (i == 0) {
            LSJHomeDayVC *dayVC = [[LSJHomeDayVC alloc] initWithColumnId:columnModel.columnId];
            [contrors addObject:dayVC];
        } else if (i == 1) {
            LSJHomeRecommdVC *recommdVC = [[LSJHomeRecommdVC alloc] initWithColumnId:columnModel.columnId];
            [contrors addObject:recommdVC];
        } else if (i == 2) {
            LSJHomeCategoryVC *cateVC = [[LSJHomeCategoryVC alloc] initWithColumnId:columnModel.columnId];
            [contrors addObject:cateVC];
        } else if (i == 3) {
            LSJHomeRankVC *rankVC = [[LSJHomeRankVC alloc] initWithColumnId:columnModel.columnId];
            [contrors addObject:rankVC];
        }
    }
    
    _cursorView.controllers = [contrors copy];
    //设置字体和颜色
    _cursorView.normalColor = [UIColor colorWithHexString:@"#555555"];
    _cursorView.normalFont = [UIFont systemFontOfSize:[LSJUtil isIpad] ? 21 : kWidth(34)];
    
    _cursorView.selectedColor = [UIColor colorWithHexString:@"#222222"];
    _cursorView.selectedFont = [UIFont systemFontOfSize:[LSJUtil isIpad] ? 23 : kWidth(38)];
    _cursorView.backgroundColor = [UIColor clearColor];
    
    _cursorView.lineView.backgroundColor = [UIColor colorWithHexString:@"#222222"];
    _cursorView.lineEdgeInsets = UIEdgeInsetsMake(kWidth(2.), 3, 2, 3);
    
    [self.view addSubview:_cursorView];
    _cursorView.currentIndex = 1;
    //属性设置完成后，调用此方法绘制界面
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 100, 20, 100, 44)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor colorWithHexString:@"#ffe100"];
    [self.view addSubview:view];
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"精品专区" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:[LSJUtil isIpad] ? 20 : kWidth(30)];
    btn.layer.cornerRadius = [LSJUtil isIpad] ? 10 : kWidth(20);
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [btn setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:UIControlStateNormal];
    [view addSubview:btn];
    
    [view bk_whenTapped:^{
        [self skipAppSpreadView];
    }];
    
    [btn bk_addEventHandler:^(id sender) {
        [self skipAppSpreadView];
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    _cursorView.collectionViewWidth = ^(CGFloat width) {
        view.frame = CGRectMake(width, 20, kScreenWidth - width, 44);
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.right.equalTo(view).offset(-kWidth(20));
            make.size.mas_equalTo([LSJUtil isIpad] ?CGSizeMake(110, 30) : CGSizeMake(kWidth(140), kWidth(60)));
        }];
    };
    
    [_cursorView reloadPages];
}

- (void)skipAppSpreadView {
    LSJHomeAppVC *appVC = [[LSJHomeAppVC alloc] initWithTitle:@"精品专区"];
    [self.navigationController pushViewController:appVC animated:YES];
    [[LSJStatsManager sharedManager] statsStopDurationAtTabIndex:self.tabBarController.selectedIndex subTabIndex:[LSJUtil gerCurrentHomeSub]];
    [[LSJStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:4 forClickCount:1];
    [LSJUtil setCurrenthHomenSub:4];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma SDCursorViewDelegate
- (void)sendOriginalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [[LSJStatsManager sharedManager] statsStopDurationAtTabIndex:self.tabBarController.selectedIndex subTabIndex:originalIndex];
    [[LSJStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:targetIndex forClickCount:1];
    [LSJUtil setCurrenthHomenSub:originalIndex];
}

@end
