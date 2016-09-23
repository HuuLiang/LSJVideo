//
//  LSJAppCell.m
//  LSJVideo
//
//  Created by Liang on 16/8/15.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJAppCell.h"

@interface LSJAppCell ()
{
    UIImageView *_imgV;
    UILabel *_titleLabel;
    UILabel *_sizeLabel;
    UILabel *_countLabel;
    UILabel *_detailLabel;
}
@end

@implementation LSJAppCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *grayView = [[UIView alloc] init];
        grayView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self addSubview:grayView];
        
        _imgV = [[UIImageView alloc] init];
        _imgV.layer.cornerRadius = kWidth(22);
        _imgV.layer.masksToBounds = YES;
        [grayView addSubview:_imgV];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(36)];
        [grayView addSubview:_titleLabel];
        
        _sizeLabel = [[UILabel alloc] init];
        _sizeLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _sizeLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [grayView addSubview:_sizeLabel];
        
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _countLabel.font = [UIFont systemFontOfSize:kWidth(28.)];
        [grayView addSubview:_countLabel];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _detailLabel.numberOfLines = 0;
        _detailLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [grayView addSubview:_detailLabel];
        
        {
            [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
                make.top.equalTo(self).offset(kWidth(20));
            }];
            
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(grayView);
                make.left.equalTo(grayView).offset(kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(240), kWidth(240)));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(grayView).offset(kWidth(30));
                make.left.equalTo(_imgV.mas_right).offset(kWidth(20));
                make.height.mas_equalTo(kWidth(50));
            }];
            
            [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_titleLabel.mas_bottom).offset(kWidth(10));
                make.left.equalTo(_imgV.mas_right).offset(kWidth(20));
                make.height.mas_equalTo(kWidth(40));
            }];
            
            [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_sizeLabel);
                make.left.equalTo(_sizeLabel.mas_right).offset(kWidth(52));
                make.height.mas_equalTo(kWidth(40));
            }];
            
            [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_sizeLabel.mas_bottom).offset(kWidth(15));
                make.left.equalTo(_imgV.mas_right).offset(kWidth(20));
                make.right.equalTo(grayView).offset(-kWidth(20));
            }];
            
        }

        
    }
    return self;
}


- (void)setImgUrlStr:(NSString *)imgUrlStr {
    [_imgV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}

- (void)setSizeStr:(NSString *)sizeStr {
    _sizeLabel.text = [NSString stringWithFormat:@"大小:%@",sizeStr];
}

- (void)setCountStr:(NSString *)countStr {
    _countLabel.text = [NSString stringWithFormat:@"下载量:%@",countStr];
}

- (void)setDetailStr:(NSString *)detailStr {
    _detailLabel.text = detailStr;
}


@end
