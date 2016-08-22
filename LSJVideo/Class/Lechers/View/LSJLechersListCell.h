//
//  LSJLechersListCell.h
//  LSJVideo
//
//  Created by Liang on 16/8/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSJColumnModel.h"
#define kImageWidth (kScreenWidth - kWidth(40) - kWidth(20))/2.5
#define kCellHeight kImageWidth * 9 / 7 + kWidth(140)

@interface LSJLechersListCell : UITableViewCell
@property (nonatomic) NSString *titleStr;
@property (nonatomic) NSArray <LSJColumnModel *>*dataArr;
@property (nonatomic) LSJAction action;
@end
