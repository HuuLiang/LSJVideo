//
//  LSJWelfareCell.h
//  LSJVideo
//
//  Created by Liang on 16/8/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kImageWidth (kScreenWidth - kWidth(40))/3
#define kCellHeight kImageWidth * 9 / 7 + kWidth(160)

@interface LSJWelfareCell : UITableViewCell

@property (nonatomic) NSString *titleStr;
@property (nonatomic) NSString *imgAUrlStr;
@property (nonatomic) NSString *imgBUrlStr;
@property (nonatomic) NSString *imgCUrlStr;
@property (nonatomic) NSString *timeStr;
@property (nonatomic) NSString *commandStr;

@end
