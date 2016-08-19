//
//  LSJWelfareCell.m
//  LSJVideo
//
//  Created by Liang on 16/8/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJWelfareCell.h"

@interface LSJWelfareCell ()
{
    UILabel *_titleLabel;
    UIImageView *_imgVA;
    UIImageView *_imgVB;
    UIImageView *_imgVC;
    UILabel *_timeLabel;
    UILabel *_countLabel;
    UILabel *_commandLabel;
}
@end

@implementation LSJWelfareCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self addSubview:bgView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        _titleLabel.backgroundColor = [UIColor yellowColor];
        [bgView addSubview:_titleLabel];
        
        _imgVA = [[UIImageView alloc] init];
        _imgVA.backgroundColor = [UIColor redColor];
        [bgView addSubview:_imgVA];
        
        _imgVB = [[UIImageView alloc] init];
        _imgVB.backgroundColor = [UIColor redColor];
        [bgView addSubview:_imgVB];
        
        _imgVC = [[UIImageView alloc] init];
        _imgVC.backgroundColor = [UIColor redColor];
        [bgView addSubview:_imgVC];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _timeLabel.font = [UIFont systemFontOfSize:kWidth(24)];
        _timeLabel.backgroundColor = [UIColor cyanColor];
        [bgView addSubview:_timeLabel];
        
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _countLabel.font = [UIFont systemFontOfSize:kWidth(24)];
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.backgroundColor = [UIColor blueColor];
        [bgView addSubview:_countLabel];
        
        _commandLabel = [[UILabel alloc] init];
        _commandLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _commandLabel.font = [UIFont systemFontOfSize:kWidth(24)];
        _commandLabel.backgroundColor = [UIColor brownColor];
        [bgView addSubview:_commandLabel];
        
        
        {
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self);
                make.height.mas_equalTo(kCellHeight - kWidth(20));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(bgView);
                make.height.mas_equalTo(kWidth(80));
            }];
            
            [_imgVA mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bgView.mas_left).offset(kWidth(10));
                make.top.equalTo(_titleLabel.mas_bottom);
                make.size.mas_equalTo(CGSizeMake(kImageWidth, kImageWidth * 9 /7));
            }];
            
            [_imgVB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_imgVA.mas_right).offset(kWidth(10));
                make.top.equalTo(_titleLabel.mas_bottom);
                make.size.mas_equalTo(CGSizeMake(kImageWidth, kImageWidth * 9 /7));
            }];
            
            [_imgVC mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_imgVB.mas_right).offset(kWidth(10));
                make.top.equalTo(_titleLabel.mas_bottom);
                make.size.mas_equalTo(CGSizeMake(kImageWidth, kImageWidth * 9 /7));
            }];
            
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bgView.mas_left).offset(kWidth(10));
                make.top.equalTo(_imgVA.mas_bottom);
                make.bottom.equalTo(bgView);
            }];

            [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_imgVC.mas_bottom);
                make.bottom.equalTo(bgView);
                make.right.equalTo(_imgVC.mas_centerX);
            }];
            
            [_commandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_imgVC.mas_bottom);
                make.bottom.equalTo(bgView);
                make.left.equalTo(_imgVC.mas_centerX);
            }];
        }
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}

- (void)setImgAUrlStr:(NSString *)imgAUrlStr {
    
}

- (void)setImgBUrlStr:(NSString *)imgBUrlStr {
    
}

- (void)setImgCUrlStr:(NSString *)imgCUrlStr {
    
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeLabel.text = timeStr;
}

- (void)setCountStr:(NSString *)countStr {
    _countLabel.text = countStr;
}

- (void)setCommandStr:(NSString *)commandStr {
    _commandLabel.text = commandStr;
}

@end
