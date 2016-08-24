//
//  LSJDayCell.h
//  LSJVideo
//
//  Created by Liang on 16/8/24.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSJDayCell : UITableViewCell
@property (nonatomic) NSString *imgUrlStr;
@property (nonatomic) NSString *titleStr;
@property (nonatomic) NSInteger contactCount;
@property (nonatomic) NSArray *userContacts;
@property (nonatomic) BOOL start;
@end
