//
//  LSJLechersListVC.m
//  LSJVideo
//
//  Created by Liang on 16/8/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJLechersListVC.h"
#import "LSJLechersDetailVC.h"

#import "SDCursorView.h"

@interface LSJLechersListVC ()
{
    NSArray *_array;
    NSInteger _index;
    SDCursorView *_cursorView;
}
@property (nonatomic) LSJLecherColumnsModel *lecherColumn;
@end

@implementation LSJLechersListVC
DefineLazyPropertyInitialization(LSJLecherColumnsModel, lecherColumn)

- (instancetype)initWithColumn:(LSJLecherColumnsModel *)lecherColumn andIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        self.lecherColumn = lecherColumn;
        _index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#ffe100"] colorWithAlphaComponent:0.99];

    [self create];
}

- (void)create {
    
    _cursorView = [[SDCursorView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(70))];
    _cursorView.isHomeView = NO;
    //设置子页面容器的高度
    _cursorView.contentViewHeight = kScreenHeight - kWidth(70) - 64;
    _cursorView.cursorEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    //设置控件所在controller
    _cursorView.parentViewController = self;
    
    //设置所有子controller
    NSMutableArray *contrors = [NSMutableArray array];
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (LSJColumnModel *column in _lecherColumn.columnList) {
        LSJLechersDetailVC *lecherDetailVC = [[LSJLechersDetailVC alloc] initWithColumn:column];
        [contrors addObject:lecherDetailVC];
        [titles addObject:column.name];
    }
    _cursorView.titles = titles;
    _cursorView.controllers = [contrors copy];
    //设置字体和颜色
    _cursorView.normalColor = [UIColor colorWithHexString:@"#333333"];
    _cursorView.normalFont = [UIFont systemFontOfSize:kWidth(30.)];
    
    _cursorView.selectedColor = [UIColor colorWithHexString:@"#333333"];
    _cursorView.selectedFont = [UIFont boldSystemFontOfSize:kWidth(30.)];
    _cursorView.backgroundColor = [UIColor clearColor];
    
    _cursorView.lineView.backgroundColor = [UIColor colorWithHexString:@"#ff227a"];
    _cursorView.lineEdgeInsets = UIEdgeInsetsMake(1, kWidth(34), -1, 2);
    
    [self.view addSubview:_cursorView];
    _cursorView.currentIndex = _index;
    //属性设置完成后，调用此方法绘制界面
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 100, 20, 100, 44)];
//    view.backgroundColor = [UIColor colorWithHexString:@"#ffe100"];
//    [self.view addSubview:view];
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"精品专区" forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:kWidth(24.)];
//    btn.layer.cornerRadius = kWidth(26.);
//    btn.layer.masksToBounds = YES;
//    btn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
//    [btn setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:UIControlStateNormal];
//    [view addSubview:btn];
//    
//    [btn bk_addEventHandler:^(id sender) {
//        LSJHomeAppVC *appVC = [[LSJHomeAppVC alloc] initWithTitle:@"精品专区"];
//        [self.navigationController pushViewController:appVC animated:YES];
//    } forControlEvents:UIControlEventTouchUpInside];
    
    
    _cursorView.collectionViewWidth = ^(CGFloat width) {
//        view.frame = CGRectMake(width, 20, kScreenWidth - width, 44);
//        
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(view);
//            make.right.equalTo(view).offset(-kWidth(14.));
//            make.size.mas_equalTo(CGSizeMake(kWidth(128.), kWidth(52.)));
//        }];
    };
    
    [_cursorView reloadPages];
}

- (void)viewWillAppear:(BOOL)animated {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
//    [_cursorView selectItemAtIndex:_index];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}@end
