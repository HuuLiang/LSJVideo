//
//  LSJCategoryCell.h
//  LSJVideo
//
//  Created by Liang on 16/8/15.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSJCategoryCell : UICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic) NSString *imgUrl;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *colorHexStr;

@end
