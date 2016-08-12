//
//  LSJRecommdCell.m
//  LSJVideo
//
//  Created by Liang on 16/8/11.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJRecommdCell.h"

@interface LSJRecommdCell ()
{
    UIImageView *_bgImgV;
    UILabel *_titleLabel;
}
@end

@implementation LSJRecommdCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
        
        _bgImgV = [[UIImageView alloc] init];
        _bgImgV.layer.cornerRadius = kWidth(4);
        _bgImgV.layer.masksToBounds = YES;
        [self addSubview:_bgImgV];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(15)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(self);
                make.height.mas_equalTo(kWidth(21));
            }];
            
            [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(self);
                make.bottom.equalTo(_titleLabel.mas_top);
            }];
        }
    }
    return self;
}

- (void)setImgUrl:(NSString *)imgUrl {
    [_bgImgV sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

@end
