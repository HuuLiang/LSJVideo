//
//  LSJPaymentTypeCell.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJPaymentTypeCell.h"
#import "LSJBtnView.h"

@interface LSJPaymentTypeCell ()
{
    UIImageView *_imgV;
    UILabel *_label;
    
    LSJBtnView *_wxPay;
    LSJBtnView *_aliPay;
}
@end

@implementation LSJPaymentTypeCell

- (instancetype)initWithPaymentTypes:(NSArray *)availablePaymentTypes
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        for (NSDictionary *payDic in availablePaymentTypes) {
            if ([payDic[@"subType"] unsignedIntegerValue] == QBPaySubTypeWeChat) {
                @weakify(self);
                _wxPay = [[LSJBtnView alloc] initWithNormalTitle:@"微信支付" selectedTitle:@"微信支付" normalImage:[UIImage imageNamed:@"vip_normal"] selectedImage:[UIImage imageNamed:@"vip_selected"] space:kWidth(10) isTitleFirst:NO touchAction:^{
                    @strongify(self);
                    
                    self.selectionAction([payDic[@"type"] unsignedIntegerValue],[payDic[@"subType"] unsignedIntegerValue]);
                    if (self->_wxPay.isSelected) {
                        return ;
                    } else if (self->_aliPay) {
                        self->_wxPay.isSelected = !self->_wxPay.isSelected;
                        self->_aliPay.isSelected = !self->_aliPay.isSelected;
                    }
                }];
                _wxPay.titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
                _wxPay.titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
                [self addSubview:_wxPay];
            }
            
            if ([payDic[@"subType"] unsignedIntegerValue] == QBPaySubTypeAlipay) {
                @weakify(self);
                _aliPay = [[LSJBtnView alloc] initWithNormalTitle:@"支付宝支付" selectedTitle:@"支付宝支付" normalImage:[UIImage imageNamed:@"vip_normal"] selectedImage:[UIImage imageNamed:@"vip_selected"] space:kWidth(10) isTitleFirst:NO touchAction:^{
                    @strongify(self);
                    self.selectionAction([payDic[@"type"] unsignedIntegerValue],[payDic[@"subType"] unsignedIntegerValue]);
                    if (self->_aliPay.isSelected) {
                        return ;
                    } else if (self->_wxPay) {
                        self->_wxPay.isSelected = !self->_wxPay.isSelected;
                        self->_aliPay.isSelected = !self->_aliPay.isSelected;
                    }
                }];
                _aliPay.titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
                _aliPay.titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
                [self addSubview:_aliPay];
            }
        }
        
        if (_wxPay && _aliPay) {
            _wxPay.isSelected = YES;
            [_wxPay mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(self.mas_centerX).offset(-kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(150), kWidth(40)));
            }];
            
            [_aliPay mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self.mas_centerX).offset(kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(150), kWidth(40)));
            }];
        } else if ((_wxPay && !_aliPay) || (!_wxPay && _aliPay))  {
            if (_wxPay) {
                _wxPay.isSelected = YES;
                _wxPay.userInteractionEnabled = NO;
                [_wxPay mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self);
                    make.size.mas_equalTo(CGSizeMake(kWidth(150), kWidth(40)));
                }];
            }
            if (_aliPay) {
                _aliPay.isSelected = YES;
                _aliPay.userInteractionEnabled = NO;
                [_wxPay mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self);
                    make.size.mas_equalTo(CGSizeMake(kWidth(150), kWidth(40)));
                }];
            }
            
        }
        
        
    }
    return self;
}

@end
