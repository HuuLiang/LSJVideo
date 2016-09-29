//
//  LSJBannerVipCell.m
//  LSJVideo
//
//  Created by Liang on 16/9/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJBannerVipCell.h"

@interface LSJBannerVipCell ()
{
    UIImageView *_bgImgV;
    UIImageView *_vipImgV;
    UIButton *_vipBtn;
}
@end

@implementation LSJBannerVipCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
        
        _bgImgV = [[UIImageView alloc] init];
        [self addSubview:_bgImgV];
        
        _vipImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_vip"]];
        [self addSubview:_vipImgV];
        
        _vipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vipBtn setTitle:@"立即开通VIP" forState:UIControlStateNormal];
        _vipBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(26)];
        _vipBtn.backgroundColor = [UIColor colorWithHexString:@"#ffe100"];
        [_vipBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _vipBtn.layer.cornerRadius = kWidth(8);
        _vipBtn.layer.masksToBounds = YES;
        [self addSubview:_vipBtn];
        
        @weakify(self);
        [_vipBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.action) {
                self.action();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        {
            [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            [_vipImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(kWidth(40));
                make.size.mas_equalTo(CGSizeMake(kWidth(184), kWidth(144)));
            }];
            
            [_vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self).offset(-kWidth(36));
                make.size.mas_equalTo(CGSizeMake(kWidth(200), kWidth(50)));
            }];
        }
        
    }
    return self;
}

- (void)setBgUrl:(NSString *)bgUrl {
    [_bgImgV sd_setImageWithURL:[NSURL URLWithString:bgUrl]];
}

@end
