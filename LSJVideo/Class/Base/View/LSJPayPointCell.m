//
//  LSJPayPointCell.m
//  LSJVideo
//
//  Created by Liang on 16/9/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJPayPointCell.h"
#import "LSJBtnView.h"
#import "LSJSystemConfigModel.h"

@interface LSJPayPointCell ()
{
    UILabel *_titleLabel;
    UILabel *_detailLabel;
    UILabel *_reduceLabel;
    LSJBtnView *_payBtn;
    NSUInteger _price;
    LSJVipLevel _selectedVipLevel;
    UIView *_shadeView;
}
@end

@implementation LSJPayPointCell

- (instancetype)initWithCurrentVipLevel:(LSJVipLevel)vipLevel IndexPathRow:(NSInteger)row
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [self addSubview:_titleLabel];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:kWidth(22)];
        _detailLabel.textColor = [[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0.7];
        [self addSubview:_detailLabel];
        
        _payBtn = [[LSJBtnView alloc] initWithTitle:@"" normalImage:[UIImage imageNamed:@"vip_into"] selectedImage:nil isTitleFirst:YES];
        _payBtn.space = kWidth(4);
        _payBtn.titleFont = [UIFont systemFontOfSize:kWidth(22)];
        _payBtn.titleColor = [UIColor colorWithHexString:@"#ffffff"];
        _payBtn.layer.cornerRadius = kWidth(10);
        _payBtn.layer.masksToBounds = YES;
        [self addSubview:_payBtn];
        
        _reduceLabel = [[UILabel alloc] init];
        _reduceLabel.font = [UIFont systemFontOfSize:kWidth(22)];
        _reduceLabel.textColor = [[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0.7];
        _reduceLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_reduceLabel];
        
        UIImageView *_lineImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_line"]];
        [self addSubview:_lineImgV];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.userInteractionEnabled = YES;
        bgView.layer.cornerRadius = [LSJUtil isIpad] ? 10 : kWidth(10);
        bgView.layer.borderColor = [[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0.54].CGColor;
        bgView.layer.borderWidth = [LSJUtil isIpad] ? 2 : kWidth(2);
        [self addSubview:bgView];
        
        {
            if (row == 0) {
                if (vipLevel == LSJVipLevelNone) {
                    _titleLabel.text = @"普通VIP";
                    _detailLabel.text = @"观看除浪友圈外所有视频";
                    _price = [LSJSystemConfigModel sharedModel].payAmount;
                    _payBtn.normalTitle = [NSString stringWithFormat:@"特价:%ld元",_price/100];
                    _payBtn.backgroundColor = [UIColor colorWithHexString:@"#"];
                    _reduceLabel.text = @"原价88元";
                    _selectedVipLevel = LSJVipLevelVip;
                    _payBtn.bgColor = [UIColor colorWithHexString:@"#ff8a44"];
                } else if (vipLevel == LSJVipLevelVip) {
                    _titleLabel.text = @"升级黑钻VIP";
                    _titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
                    _detailLabel.text = @"黑钻会员永久有效(定期更新)";
                    _detailLabel.textColor = [UIColor colorWithHexString:@"#000000"];
                    _price = [LSJSystemConfigModel sharedModel].svipPayAmount - [LSJSystemConfigModel sharedModel].payAmount;
                    _payBtn.normalTitle = [NSString stringWithFormat:@"特价:%ld元",_price/100];
                    _reduceLabel.text = @"原价108元";
                    _reduceLabel.textColor = [UIColor colorWithHexString:@"#333333"];
                    _payBtn.bgColor = [UIColor colorWithHexString:@"#e63e61"];
                    _selectedVipLevel = LSJVipLevelSVip;
                    _shadeView = [[UIView alloc] init];
                    _shadeView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
                    [self insertSubview:_shadeView atIndex:0];
                }
                
            } else if (row == 1) {
                if (vipLevel == LSJVipLevelNone) {
                    _titleLabel.text = @"黑钻VIP";
                    _detailLabel.text = @"观看所有视频(定期更新)";
                    _price = [LSJSystemConfigModel sharedModel].svipPayAmount;
                    _payBtn.normalTitle = [NSString stringWithFormat:@"特价:%ld元",_price/100];
                    _reduceLabel.text = @"原价108元";
                    _selectedVipLevel = LSJVipLevelSVip;
                    

                }
                _payBtn.backgroundColor = [UIColor colorWithHexString:@"#e61e63"];
            }
        }
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(40));
                make.bottom.equalTo(self.mas_centerY).offset(-kWidth(5));
                make.height.mas_equalTo(kWidth(30));
            }];
            
            [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kWidth(40));
                make.top.equalTo(self.mas_centerY).offset(kWidth(8));
                make.height.mas_equalTo(kWidth(25));
            }];
            
            [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(self).offset(-kWidth(40));
                make.size.mas_equalTo(CGSizeMake(kWidth(140), kWidth(54)));
            }];
            
            [_reduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(_payBtn.mas_left).offset(-kWidth(20));
                make.height.mas_equalTo(kWidth(30));
            }];
            
            [_lineImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_reduceLabel);
            }];
            
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.mas_equalTo(UIEdgeInsetsMake(kWidth(10), kWidth(20), kWidth(10), kWidth(20)));
                make.left.equalTo(self).offset(kWidth(20));
                make.right.equalTo(self).offset(-kWidth(20));
                make.centerY.equalTo(self);
                make.height.mas_equalTo(kWidth(110));
            }];
            
            if (_shadeView) {
                [_shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(kWidth(20));
                    make.right.equalTo(self).offset(-kWidth(20));
                    make.centerY.equalTo(self);
                    make.height.mas_equalTo(kWidth(110));
                }];
            }
        }
        
        @weakify(self);
        [bgView bk_whenTapped:^{
            @strongify(self);
            self.action(@(self->_selectedVipLevel));
        }];
        
    }
    return self;
}

@end
