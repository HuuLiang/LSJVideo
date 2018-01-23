//
//  LSJDayCell.h
//  LSJVideo
//
//  Created by Liang on 16/8/24.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSJProgramModel.h"

@interface LSJDayCell : UITableViewCell
@property (nonatomic) NSString *imgUrlStr;
@property (nonatomic) NSString *titleStr;
@property (nonatomic) NSString * contact;
@property (nonatomic) NSArray <LSJCommentModel *> *userComments;
@property (nonatomic) BOOL start;
@end
