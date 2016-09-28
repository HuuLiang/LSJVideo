//
//  LSJCategoryCell.m
//  LSJVideo
//
//  Created by Liang on 16/8/15.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJCategoryCell.h"

@interface LSJCategoryCell ()
{
    UIImageView *_bgImgV;
    UILabel *_titleLabel;
    UIView *_tagView;
}
@end

@implementation LSJCategoryCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_category_bgV"]];
//        imageV.layer.masksToBounds = YES;
        [self addSubview:imageV];
        
        
        _bgImgV = [[UIImageView alloc] init];
        _bgImgV.layer.cornerRadius = kWidth(6);
        _bgImgV.layer.masksToBounds = YES;
        [imageV addSubview:_bgImgV];
        
        UIImageView *imgBV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_category_black"]];
        [_bgImgV addSubview:imgBV];
        

        
//        UIImageView *tagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_category_tag"]];
//        tagView.alpha = 0.65;
//        [_bgImgV addSubview:tagView];
        _tagView = [[UIView alloc] init];
        _tagView.layer.cornerRadius = kWidth(30);
        _tagView.layer.masksToBounds = YES;
        [_bgImgV addSubview:_tagView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [_tagView addSubview:_titleLabel];
        
        {
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.centerX.equalTo(imageV);
                make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(self.frame) * 344 / 353. , CGRectGetWidth(self.frame) * 344 / 353. * 458 / 353.));
            }];
            
            [imgBV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.left.equalTo(_bgImgV);
                make.height.mas_equalTo(CGRectGetWidth(self.frame) * 344 / 353. * 458 / 353.);
            }];
            
            [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_bgImgV.mas_right);
                make.top.equalTo(_bgImgV.mas_top).offset(kWidth(40.));
                make.size.mas_equalTo(CGSizeMake(kWidth(210), kWidth(62)));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.centerY.equalTo(_tagView);
                make.centerX.equalTo(_tagView.mas_centerX).multipliedBy(0.55);
            }];
        }
    }
    return self;
}

- (void)setImgUrl:(NSString *)imgUrl {
    [_bgImgV sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"place_79"]];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = [title substringToIndex:2];
}

- (void)setColorHexStr:(NSString *)colorHexStr {
    _tagView.backgroundColor = [[UIColor colorWithHexString:colorHexStr] colorWithAlphaComponent:0.65];
}

@end
