//
//  LSJRankCell.m
//  LSJVideo
//
//  Created by Liang on 16/8/16.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJRankCell.h"
@interface LSJRankCell ()
{
    UIImageView *_bgImgV;
    UILabel *_rankLabel;
    
    UIView *_shadeView;
    UILabel *_titleLabel;
    
    UILabel *_hotLabel;
}
@end

@implementation LSJRankCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        
        _bgImgV = [[UIImageView alloc] init];
        _bgImgV.layer.cornerRadius = kWidth(6);
        _bgImgV.layer.masksToBounds = YES;
        [self addSubview:_bgImgV];
        
        UIImageView *cupImgV= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_rank_cup"]];
        [_bgImgV addSubview:cupImgV];
        
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _rankLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [_bgImgV addSubview:_rankLabel];
        
        
        _shadeView = [[UIView alloc] init];
        _shadeView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.45];
        _shadeView.layer.cornerRadius = kWidth(30);
        _shadeView.layer.masksToBounds = YES;
        [_bgImgV addSubview:_shadeView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [_shadeView addSubview:_titleLabel];
        
        UIImageView *intoImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_rank_into"]];
        [_shadeView addSubview:intoImgV];
        
        UIImageView *therImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_rank_thermometer"]];
        [_bgImgV addSubview:therImgV];
        
        _hotLabel = [[UILabel alloc] init];
        _hotLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _hotLabel.font = [UIFont systemFontOfSize:kWidth(24)];
        [_bgImgV addSubview:_hotLabel];
        
        {
            [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            [cupImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(kWidth(10)));
                make.left.equalTo(@(kWidth(12)));
                make.size.mas_equalTo(CGSizeMake(kWidth(46), kWidth(36)));
            }];
            
            [_rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cupImgV);
                make.left.equalTo(cupImgV.mas_right).offset(kWidth(10));
                make.height.mas_equalTo(kWidth(40));
            }];
            
            [_shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_bgImgV);
                make.top.equalTo(_bgImgV.mas_top).offset(kWidth(306));
//                make.size.mas_equalTo(CGSizeMake(kWidth(105), kWidth(62)));
                make.height.mas_equalTo(kWidth(60));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_shadeView);
                make.height.mas_equalTo(kWidth(42));
                make.centerX.equalTo(_shadeView.mas_centerX).offset(-kWidth(12.4));
            }];
            
            [intoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_shadeView);
                make.left.equalTo(_titleLabel.mas_right).offset(kWidth(8));
                make.size.mas_equalTo(CGSizeMake(kWidth(16.8), kWidth(28)));
            }];
            
            [therImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_bgImgV.mas_bottom).offset(-kWidth(6));
                make.left.equalTo(_bgImgV.mas_left).offset(kWidth(180));
                make.size.mas_equalTo(CGSizeMake(kWidth(22.8), kWidth(44)));
            }];
            
            [_hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(therImgV).offset(kWidth(5));
                make.left.equalTo(therImgV.mas_right).offset(kWidth(5));
                make.height.mas_equalTo(kWidth(34));
            }];
        }
    }
    return self;
}

- (void)setImgUrl:(NSString *)imgUrl {
    [_bgImgV sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"place_79"]];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}

- (void)setHotCount:(NSInteger)hotCount {
    _hotLabel.text = [NSString stringWithFormat:@"%ld°C",hotCount];
}

- (void)setRank:(NSInteger)rank {
    if (rank <= 9) {
        _rankLabel.text = [NSString stringWithFormat:@"NO.%ld",rank+1];
    }
}

- (void)setWidth:(CGFloat)width {
    [_shadeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgImgV);
        make.top.equalTo(_bgImgV.mas_top).offset(kWidth(306));
        make.size.mas_equalTo(CGSizeMake(width+kWidth(60), kWidth(60)));
    }];
}

@end
