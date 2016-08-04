//
//  LSJMessageCenter.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSJMessageCenter : NSObject
+ (instancetype)defaultCenter;
- (instancetype)init __attribute__((unavailable("cannot use init for this class, use +(instancetype)defaultCenter instead")));

- (void)showMessageWithTitle:(NSString *)title inViewController:(UIViewController *)viewController;
- (void)showWarningWithTitle:(NSString *)title inViewController:(UIViewController *)viewController;
- (void)showErrorWithTitle:(NSString *)title inViewController:(UIViewController *)viewController;
- (void)showSuccessWithTitle:(NSString *)title inViewController:(UIViewController *)viewController;

- (void)dismissMessageWithCompletion:(void (^)(void))completion;

- (void)showProgressWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
- (void)proceedProgressWithPercent:(double)percent;
- (void)hideProgress;

@end

#define LSJShowMessage(_title) [[LSJMessageCenter defaultCenter] showMessageWithTitle:_title inViewController:nil]
#define LSJShowWarning(_title) [[LSJMessageCenter defaultCenter] showWarningWithTitle:_title inViewController:nil]
#define LSJShowError(_title)   [[LSJMessageCenter defaultCenter] showErrorWithTitle:_title inViewController:nil]
#define LSJShowSuccess(_title) [[LSJMessageCenter defaultCenter] showSuccessWithTitle:_title inViewController:nil]
