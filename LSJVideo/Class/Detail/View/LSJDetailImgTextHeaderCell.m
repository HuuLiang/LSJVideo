//
//  LSJDetailImgTextHeaderCell.m
//  LSJVideo
//
//  Created by Liang on 16/9/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJDetailImgTextHeaderCell.h"

@interface LSJDetailImgTextHeaderCell ()
{
    UILabel *_titleLabel;
    UILabel *_timeLabel;
    UILabel *_nameLabel;
}
@end


@implementation LSJDetailImgTextHeaderCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(40)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        [self addSubview:_timeLabel];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        [self addSubview:_nameLabel];
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(32));
                make.top.equalTo(self).offset(kWidth(30));
                make.right.equalTo(self).offset(-kWidth(32));
            }];
            
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(32));
                make.bottom.equalTo(self);
                make.height.mas_equalTo(kWidth(32));
            }];
            
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_timeLabel.mas_right).offset(kWidth(30));
                make.bottom.equalTo(self);
                make.height.mas_equalTo(kWidth(32));
            }];
        }
        
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeLabel.text = timeStr;
}

- (void)setNameStr:(NSString *)nameStr {
    _nameLabel.text = nameStr;
}

@end
