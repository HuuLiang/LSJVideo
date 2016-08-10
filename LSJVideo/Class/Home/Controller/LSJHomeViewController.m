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

@interface LSJHomeViewController ()
{
    SDCursorView *_cursorView;
}
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) LSJHomeModel *homeModel;
@end

@implementation LSJHomeViewController
DefineLazyPropertyInitialization(LSJHomeModel, homeModel)
DefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#ffe100"] colorWithAlphaComponent:0.99];
    
    [self.homeModel fetchHomeInfoWithCompletionHandler:^(BOOL success, id obj) {
        if (success) {
            self.dataSource = [NSMutableArray arrayWithArray:obj];
            [self create];
        }
    }];
}

- (void)create {
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (LSJHomeColumnModel *columnModel in _dataSource) {
        [titles addObject:columnModel.name];
    }
    
    _cursorView = [[SDCursorView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    //设置子页面容器的高度
    _cursorView.contentViewHeight = kScreenHeight - 44 - 49 - 20;
    _cursorView.cursorEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    //设置控件所在controller
    _cursorView.parentViewController = self;
    _cursorView.titles = titles;
    
    //设置所有子controller
    NSMutableArray *contrors = [NSMutableArray array];
    for (LSJHomeColumnModel *columnModel in _dataSource) {
        if ([columnModel.name isEqualToString:@"日狗"]) {
            LSJHomeDayVC *dayVC = [[LSJHomeDayVC alloc] init];
            [contrors addObject:dayVC];
        } else if ([columnModel.name isEqualToString:@"推荐"]) {
            LSJHomeRecommdVC *recommdVC = [[LSJHomeRecommdVC alloc] initWithColumnId:columnModel.columnId];
            [contrors addObject:recommdVC];
        } else if ([columnModel.name isEqualToString:@"分类"]) {
            LSJHomeCategoryVC *cateVC = [[LSJHomeCategoryVC alloc] init];
            [contrors addObject:cateVC];
        } else if ([columnModel.name isEqualToString:@"排行"]) {
            LSJHomeRankVC *rankVC = [[LSJHomeRankVC alloc] init];
            [contrors addObject:rankVC];
        }
    }
    _cursorView.controllers = [contrors copy];
    //设置字体和颜色
    _cursorView.normalColor = [UIColor colorWithHexString:@"#555555"];
    _cursorView.normalFont = [UIFont systemFontOfSize:kWidth(36.)];
    
    _cursorView.selectedColor = [UIColor colorWithHexString:@"#222222"];
    _cursorView.selectedFont = [UIFont systemFontOfSize:kWidth(40.)];
    _cursorView.backgroundColor = [UIColor clearColor];
    
    _cursorView.lineView.backgroundColor = [UIColor colorWithHexString:@"#222222"];
    _cursorView.lineEdgeInsets = UIEdgeInsetsMake(kWidth(2.), 3, 2, 3);
    
    [self.view addSubview:_cursorView];
    _cursorView.currentIndex = 1;
    //属性设置完成后，调用此方法绘制界面
    [_cursorView reloadPages];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
