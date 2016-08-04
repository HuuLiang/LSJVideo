//
//  LSJTableViewCell.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSJTableViewCell : UITableViewCell

@property (nonatomic,retain,readonly) UIImageView *iconImageView;
@property (nonatomic,retain,readonly) UILabel *titleLabel;
@property (nonatomic,retain,readonly) UILabel *subtitleLabel;
@property (nonatomic,retain,readonly) UIImageView *backgroundImageView;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle;

@end
