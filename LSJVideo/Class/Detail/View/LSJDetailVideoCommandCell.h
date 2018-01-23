//
//  LSJDetailVideoCommandCell.h
//  LSJVideo
//
//  Created by Liang on 16/8/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSJDetailVideoCommandCell : UITableViewCell

//- (instancetype)initWithHeight:(CGFloat)height;

@property (nonatomic) NSString *userImgUrlStr;
@property (nonatomic) NSString *timeStr;
@property (nonatomic) NSString *userNameStr;
@property (nonatomic) NSAttributedString *commandAttriStr;
@end
