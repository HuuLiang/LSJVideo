//
//  LSJLechersListCell.m
//  LSJVideo
//
//  Created by Liang on 16/8/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJLechersListCell.h"

@interface LSJLechersListCell ()
{
    UILabel *_titleLabel;
}
@end

@implementation LSJLechersListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self addSubview:bgView];
        
        UIImageView *lineView = [[UIImageView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#fee102"];
        [bgView addSubview:lineView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        [bgView addSubview:_titleLabel];
        
        {
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(self);
                make.height.mas_equalTo(kWidth(kCellHeight));
            }];
            
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bgView).offset(kWidth(10));
                make.top.equalTo(bgView).offset(kWidth(16));
                make.size.mas_equalTo(CGSizeMake(kWidth(6), kWidth(36)));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lineView.mas_right).offset(kWidth(10));
                make.centerY.equalTo(lineView);
                make.height.mas_equalTo(kWidth(44));
            }];
        }
        
    }
    return self;
}

@end
