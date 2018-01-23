//
//  LSJSpreadBannerViewController.h
//  LSJVideo
//
//  Created by Liang on 16/9/28.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJBaseViewController.h"

@class LSJProgramModel;

@interface LSJSpreadBannerViewController : LSJBaseViewController

@property (nonatomic,retain,readonly) NSArray<LSJProgramModel *> *spreads;

- (instancetype)initWithSpreads:(NSArray<LSJProgramModel *> *)spreads;
- (void)showInViewController:(UIViewController *)viewController;

@end
