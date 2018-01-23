//
//  LSJDetailVideoHeaderCell.m
//  LSJVideo
//
//  Created by Liang on 16/8/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJDetailVideoHeaderCell.h"

@interface LSJDetailVideoHeaderCell ()
{
    UIImageView *_imgV;
}
@end

@implementation LSJDetailVideoHeaderCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _imgV = [[UIImageView alloc] init];
        [self addSubview:_imgV];
        
        UIView *_shadeView = [[UIView alloc] init];
        _shadeView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.15];
        [_imgV addSubview:_shadeView];
        
        UIImageView *_playImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lecher_play"]];
        [_shadeView addSubview:_playImgV];
        
        UIImageView *_slideImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_slide"]];
        [_shadeView addSubview:_slideImgV];
        
        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            [_shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_imgV);
            }];
            
            [_playImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(_shadeView);
                make.size.mas_equalTo(CGSizeMake(kWidth(114), kWidth(114)));
            }];
            
            [_slideImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_shadeView);
                make.bottom.equalTo(_shadeView.mas_bottom).offset(-kWidth(12));
                make.size.mas_equalTo(CGSizeMake(kWidth(660), kWidth(30)));
            }];
        }
    }
    return self;
}

- (void)setImgUrlStr:(NSString *)imgUrlStr {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
}


@end
