//
//  LSJDetailVideoDescCell.m
//  LSJVideo
//
//  Created by Liang on 16/8/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJDetailVideoDescCell.h"

@interface LSJDetailVideoDescCell ()
{
    UILabel *_titleLabel;
    
    UILabel *_countLabel;
    
    UILabel *_tagLabelA;
    UILabel *_tagLabelB;
}
@end

@implementation LSJDetailVideoDescCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(34)];
        [self addSubview:_titleLabel];
        
        UIImageView *_playImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_play"]];
        [self addSubview:_playImgV];
        
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _countLabel.font = [UIFont systemFontOfSize:kWidth(26)];
        [self addSubview:_countLabel];
        
        _tagLabelA = [[UILabel alloc] init];
        _tagLabelA.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _tagLabelA.font = [UIFont systemFontOfSize:kWidth(24)];
        _tagLabelA.layer.cornerRadius = kWidth(20);
        _tagLabelA.layer.masksToBounds = YES;
        _tagLabelA.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tagLabelA];
        
        _tagLabelB = [[UILabel alloc] init];
        _tagLabelB.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _tagLabelB.font = [UIFont systemFontOfSize:kWidth(24)];
        _tagLabelB.layer.cornerRadius = kWidth(20);
        _tagLabelB.layer.masksToBounds = YES;
        _tagLabelB.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tagLabelB];
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self).offset(kWidth(20));
                make.height.mas_equalTo(kWidth(48));
            }];
            
            [_playImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-kWidth(144));
                make.top.equalTo(self).offset(kWidth(60));
                make.size.mas_equalTo(CGSizeMake(kWidth(30), kWidth(30)));
            }];
            
            [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_playImgV.mas_right).offset(kWidth(18));
                make.centerY.equalTo(_playImgV);
                make.height.mas_equalTo(kWidth(36));
            }];
            
            [_tagLabelA mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(20));
                make.bottom.equalTo(self.mas_bottom).offset(-kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(90), kWidth(40)));
            }];
            
            [_tagLabelB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_tagLabelA.mas_right).offset(kWidth(30));
                make.centerY.equalTo(_tagLabelA);
                make.size.mas_equalTo(CGSizeMake(kWidth(90), kWidth(40)));
            }];
            
        }
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}

- (void)setCountStr:(NSString *)countStr {
    _countLabel.text = countStr;
}

- (void)setTagAStr:(NSString *)tagAStr {
    _tagLabelA.text = tagAStr;
}

- (void)setTagAColor:(UIColor *)tagAColor {
    _tagLabelA.backgroundColor = tagAColor;
}

- (void)setTagBStr:(NSString *)tagBStr {
    _tagLabelB.text = tagBStr;
}

- (void)setTagBColor:(UIColor *)tagBColor {
    _tagLabelB.backgroundColor = tagBColor;
}


@end
