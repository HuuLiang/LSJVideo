//
//  LSJDetailVideoCommandCell.m
//  LSJVideo
//
//  Created by Liang on 16/8/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJDetailVideoCommandCell.h"

@interface LSJDetailVideoCommandCell ()
{
    UIImageView *_userImgV;
    UILabel *_userLabel;
    UILabel *_timeLabel;
    UILabel *_commandLabel;
}
@end

@implementation LSJDetailVideoCommandCell

- (instancetype)initWithHeight:(CGFloat)height {
    self = [super init];
    if (self) {
        _userImgV = [[UIImageView alloc] init];
        [self addSubview:_userImgV];
    
        
        _userLabel = [[UILabel alloc] init];
        _userLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _userLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        [self addSubview:_userLabel];
        
        UIImageView *_timeImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lecher_clock"]];
        [self addSubview:_timeImgV];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _timeLabel.font = [UIFont systemFontOfSize:kWidth(22)];
        [self addSubview:_timeLabel];
        
        _commandLabel = [[UILabel alloc] init];
        _commandLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _commandLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        _commandLabel.numberOfLines = 0;
        [self addSubview:_commandLabel];
        
        {
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(kWidth(30));
                make.left.equalTo(self).offset(kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(68), kWidth(68)));
            }];
            
            [_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(kWidth(30));
                make.left.equalTo(_userImgV.mas_right).offset(kWidth(15));
                make.height.mas_equalTo(kWidth(42));
            }];
            
            [_timeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_userLabel.mas_bottom).offset(kWidth(2));
                make.left.equalTo(_userImgV.mas_right).offset(kWidth(15));
                make.size.mas_equalTo(CGSizeMake(kWidth(32), kWidth(32)));
            }];
            
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_userLabel.mas_bottom).offset(kWidth(2));
                make.left.equalTo(_timeImgV.mas_right).offset(kWidth(8));
                make.height.mas_equalTo(kWidth(32));
            }];
            
            [_commandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(20));
                make.top.equalTo(_userImgV.mas_bottom).offset(kWidth(20));
                make.right.equalTo(self).offset(-kWidth(40));
//                make.height.mas_equalTo(height);
            }];
        }
    }
    return self;
}

- (void)setUserImgUrlStr:(NSString *)userImgUrlStr {
    [_userImgV sd_setImageWithURL:[NSURL URLWithString:userImgUrlStr]];
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeLabel.text = timeStr;
}

- (void)setUserNameStr:(NSString *)userNameStr {
    _userLabel.text = userNameStr;
}

- (void)setCommandStr:(NSString *)commandStr {
    _commandLabel.text = commandStr;
}

@end
