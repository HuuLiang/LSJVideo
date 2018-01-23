//
//  LSJDetailVideoVC.h
//  LSJVideo
//
//  Created by Liang on 16/8/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJLayoutViewController.h"
#import "LSJProgramModel.h"

@interface LSJDetailVideoVC : LSJLayoutViewController

- (instancetype)initWithColumnId:(NSInteger)columnId Program:(LSJProgramModel *)program baseModel:(LSJBaseModel *)baseModel;

@end
