//
//  LSJLecherProgramCell.m
//  LSJVideo
//
//  Created by Liang on 16/8/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJLecherProgramCell.h"

@interface LSJLecherProgramCell ()
{
    UIImageView *_bgImgV;
    UIImageView *_userImgV;
    UILabel *_userLabel;
    UILabel *_titleLabel;
    UILabel *_timeLabel;
    UILabel *_commandLabel;
}
@end

@implementation LSJLecherProgramCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *_bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self addSubview:_bgView];
        
        _bgImgV = [[UIImageView alloc] init];
        [_bgView addSubview:_bgImgV];
        
        UIView *_shadeView = [[UIView alloc] init];
        _shadeView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.4];
        [_bgImgV addSubview:_shadeView];
        
        UIImageView *_playImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lecher_play"]];
        [_shadeView addSubview:_playImgV];
        
        _userImgV = [[UIImageView alloc] init];
        _userImgV.layer.cornerRadius = kWidth(24);
        _userImgV.layer.masksToBounds = YES;
        [_bgView addSubview:_userImgV];
        
        _userLabel = [[UILabel alloc] init];
        _userLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _userLabel.font = [UIFont systemFontOfSize:kWidth(26)];
        [_bgView addSubview:_userLabel];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(24)];
        _timeLabel.numberOfLines = 0;
        [_bgView addSubview:_titleLabel];
        
        UIImageView *_timeImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lecher_clock"]];
        [_bgView addSubview:_timeImgV];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _timeLabel.font = [UIFont systemFontOfSize:kWidth(22)];
        [_bgView addSubview:_timeLabel];
        
        _commandLabel = [[UILabel alloc] init];
        _commandLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _commandLabel.font = [UIFont systemFontOfSize:kWidth(22)];
        [_bgView addSubview:_commandLabel];
        
        UIImageView *_commandImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lecher_contact"]];
        [_bgView addSubview:_commandImgV];
        
        {
            [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(self);
                make.height.mas_equalTo(kWidth(210));
            }];
            
            [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(_bgView);
                make.size.mas_equalTo(CGSizeMake(kWidth(350), kWidth(210)));
            }];
            
            [_shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_bgImgV);
            }];
            
            [_playImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(_shadeView);
                make.size.mas_equalTo(CGSizeMake(kWidth(58), kWidth(58)));
            }];
            
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_bgImgV.mas_right).offset(kWidth(20));
                make.top.equalTo(_bgView).offset(kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(48), kWidth(48)));
            }];
            
            [_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_userImgV);
                make.left.equalTo(_userImgV.mas_right).offset(kWidth(10));
                make.height.mas_equalTo(kWidth(30));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_bgImgV.mas_right).offset(kWidth(20));
                make.top.equalTo(_userImgV.mas_bottom).offset(18);
                make.right.equalTo(_bgView.mas_right).offset(-kWidth(45));
            }];
            
            [_timeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_bgImgV.mas_right).offset(kWidth(20));
                make.bottom.equalTo(_bgView.mas_bottom).offset(-kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(24), kWidth(24)));
            }];
            
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_timeImgV);
                make.left.equalTo(_timeImgV.mas_right).offset(kWidth(10));
            }];
            
            [_commandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_bgView.mas_right).offset(-kWidth(45));
                make.centerY.equalTo(_timeImgV);
                make.height.mas_equalTo(kWidth(30));
            }];
            
            [_commandImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_commandLabel);
                make.right.equalTo(_commandLabel.mas_left).offset(-kWidth(10));
                make.size.mas_equalTo(CGSizeMake(kWidth(26), kWidth(23)));
            }];
            
        }
    }
    return self;
}

- (void)setBgImgUrlStr:(NSString *)bgImgUrlStr {
    [_bgImgV sd_setImageWithURL:[NSURL URLWithString:bgImgUrlStr]];
}

- (void)setUserImgUrlStr:(NSString *)userImgUrlStr {
    [_userImgV sd_setImageWithURL:[NSURL URLWithString:userImgUrlStr]];
}

- (void)setUserNameStr:(NSString *)userNameStr {
    _userLabel.text = userNameStr;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeLabel.text = [self compareCurrentTime:[LSJUtil dateFromString:timeStr]];

}

- (void)setCommandCount:(NSInteger)commandCount {
    _commandLabel.text = [NSString stringWithFormat:@"%ld",commandCount];
}

- (NSString *)compareCurrentTime:(NSDate*)compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    //    DLog("%f",timeInterval);
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

@end
