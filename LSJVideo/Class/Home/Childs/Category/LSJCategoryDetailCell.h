//
//  LSJCategoryDetailCell.h
//  LSJVideo
//
//  Created by Liang on 16/8/16.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSJCategoryDetailCell : UICollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic) NSString *titleStr;
@property (nonatomic) NSString *imgUrlStr;
@property (nonatomic) NSString *tagHexStr;
@property (nonatomic) NSString *tagTitleStr;
@end
