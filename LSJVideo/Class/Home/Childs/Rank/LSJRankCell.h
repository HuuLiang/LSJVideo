//
//  LSJRankCell.h
//  LSJVideo
//
//  Created by Liang on 16/8/16.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSJRankCell : UICollectionViewCell

@property (nonatomic) NSString *imgUrl;
@property (nonatomic) NSString *titleStr;
@property (nonatomic) NSInteger hotCount;
@property (nonatomic) NSInteger rank;
@property (nonatomic) CGFloat width;
@end
