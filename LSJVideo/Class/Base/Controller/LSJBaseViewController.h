//
//  LSJBaseViewController.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSJBaseViewController : UIViewController

- (instancetype)initWithTitle:(NSString *)title;

- (void)pushToDetailVideoWithController:(UIViewController *)VC programId:(NSInteger )programId;

@end
