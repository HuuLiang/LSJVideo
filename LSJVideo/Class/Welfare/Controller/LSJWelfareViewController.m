//
//  LSJWelfareViewController.m
//  LSJVideo
//
//  Created by Liang on 16/8/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJWelfareViewController.h"
#import "LSJWelfareModel.h"

@interface LSJWelfareViewController ()
{
    
}
@property (nonatomic) LSJWelfareModel *welfareModel;
@end

@implementation LSJWelfareViewController
DefineLazyPropertyInitialization(LSJWelfareModel, welfareModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [self.welfareModel fetchWelfareInfoWithCompletionHandler:^(BOOL success, id obj) {
        
    }];
}

@end
