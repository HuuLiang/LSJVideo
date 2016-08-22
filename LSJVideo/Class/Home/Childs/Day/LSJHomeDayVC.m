//
//  LSJHomeDayVC.m
//  LSJVideo
//
//  Created by Liang on 16/8/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJHomeDayVC.h"
#import "LSJColumnConfigModel.h"

@interface LSJHomeDayVC ()
{
    NSInteger _columnId;
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic)LSJColumnConfigModel *columnModel;
@end

@implementation LSJHomeDayVC
DefineLazyPropertyInitialization(LSJColumnConfigModel, columnModel)

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
    
    self.view.backgroundColor = [UIColor cyanColor];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [self.columnModel fetchColumnsInfoWithColumnId:_columnId IsProgram:YES CompletionHandler:^(BOOL success, id obj) {
        
    }];
}

@end
