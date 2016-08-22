//
//  LSJLechersListVC.h
//  LSJVideo
//
//  Created by Liang on 16/8/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJBaseViewController.h"
#import "LSJLecherModel.h"

@interface LSJLechersListVC : LSJBaseViewController

- (instancetype)initWithColumn:(LSJLecherColumnsModel *)lecherColumn andIndex:(NSInteger)index;

@end
