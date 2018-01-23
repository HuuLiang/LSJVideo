//
//  LSJBannerVipCell.h
//  LSJVideo
//
//  Created by Liang on 16/9/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^touchBtn)(void);

@interface LSJBannerVipCell : UITableViewCell

@property (nonatomic) NSString *bgUrl;
@property (nonatomic) touchBtn action;

@end
