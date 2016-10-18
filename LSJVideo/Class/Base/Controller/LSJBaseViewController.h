//
//  LSJBaseViewController.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSJBaseModel.h"
#import "LSJProgramModel.h"

@interface LSJBaseViewController : UIViewController

- (instancetype)initWithTitle:(NSString *)title;

- (void)pushToDetailVideoWithController:(UIViewController *)VC ColumnId:(NSInteger)columnId program:(LSJProgramModel *)program baseModel:(LSJBaseModel *)baseModel;

- (void)playPhotoUrlWithModel:(LSJBaseModel *)model urlArray:(NSArray *)urlArray index:(NSInteger)index;

- (void)playVideoWithUrl:(NSString *)videoUrlStr baseModel:(LSJBaseModel *)baseModel;

- (void)payWithBaseModelInfo:(LSJBaseModel *)baseModel;

- (void)addRefreshBtnWithCurrentView:(UIView *)view withAction:(QBAction) action;
- (void)removeCurrentRefreshBtn;
@end
