//
//  LSJRecommdCell.h
//  LSJVideo
//
//  Created by Liang on 16/8/11.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSJRecommdCell : UICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic) NSString *imgUrl;
@property (nonatomic) NSString *title;

@end
