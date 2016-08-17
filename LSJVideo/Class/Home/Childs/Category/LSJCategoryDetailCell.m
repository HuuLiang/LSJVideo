//
//  LSJCategoryDetailCell.m
//  LSJVideo
//
//  Created by Liang on 16/8/16.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJCategoryDetailCell.h"

@interface LSJCategoryDetailCell ()
{
    UIImageView *_imgV;
    UILabel *_titleLabel;
    UILabel *_tagLabel;
}
@end

@implementation LSJCategoryDetailCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imgV = [[UIImageView alloc] init];
        [self addSubview:_imgV];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        [self addSubview:_titleLabel];
        
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.layer.cornerRadius = kWidth(6);
        _tagLabel.layer.masksToBounds = YES;
        _tagLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.font = [UIFont systemFontOfSize:kWidth(26)];
        [self addSubview:_tagLabel];
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self);
                make.height.mas_equalTo(CGRectGetWidth(self.frame)* 0.6);
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self);
                make.top.equalTo(_imgV.mas_bottom);
                make.left.equalTo(self).offset(kWidth(8));
                make.right.equalTo(self).offset(-kWidth(100));
            }];
            
            [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_titleLabel);
                make.right.equalTo(self.mas_right).offset(-kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(64), kWidth(36)));
            }];
        }
    }
    return self;
}

-(void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}

- (void)setImgUrlStr:(NSString *)imgUrlStr {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
}

- (void)setTagHexStr:(NSString *)tagHexStr {
    _tagLabel.backgroundColor = [UIColor colorWithHexString:tagHexStr];
}

- (void)setTagTitleStr:(NSString *)tagTitleStr {
    _tagLabel.text = tagTitleStr;
}

@end
