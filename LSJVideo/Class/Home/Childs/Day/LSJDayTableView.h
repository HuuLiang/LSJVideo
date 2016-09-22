//
//  LSJDayTableView.h
//  LSJVideo
//
//  Created by Liang on 16/8/24.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kDayTableViewCellReusableIdentifier = @"kDayTableViewCellReusableIdentifier";

@interface LSJDayTableViewCell : UITableViewCell
@property (nonatomic) NSString *userStr;
@property (nonatomic) NSString *content;
@end

@interface LSJDayTableView : UITableView
@end
