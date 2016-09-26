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
                _wxPay = [[LSJBtnView alloc] initWithTitle:@"微信支付" normalImage:[UIImage imageNamed:@"vip_normal"] selectedImage:[UIImage imageNamed:@"vip_selected"] isTitleFirst:NO];
                _wxPay.selectedTitle = @"微信支付";
                _wxPay.titleFont = [UIFont systemFontOfSize:kWidth(22)];
                _wxPay.titleColor = [UIColor colorWithHexString:@"#ffffff"];
                [self addSubview:_wxPay];
                
                @weakify(self);
                _wxPay.action = ^ {
                    @strongify(self);
                    self.selectionAction([payDic[@"type"] unsignedIntegerValue],[payDic[@"subType"] unsignedIntegerValue]);
                    if (self->_wxPay.isSelected) {
                        return ;
                    } else if (self->_aliPay) {
                        self->_wxPay.isSelected = !self->_wxPay.isSelected;
                        self->_aliPay.isSelected = !self->_aliPay.isSelected;
                    }
                };
            }
            
            if ([payDic[@"subType"] unsignedIntegerValue] == QBPaySubTypeAlipay) {
                _aliPay = [[LSJBtnView alloc] initWithTitle:@"支付宝支付" normalImage:[UIImage imageNamed:@"vip_normal"] selectedImage:[UIImage imageNamed:@"vip_selected"] isTitleFirst:NO];
                _aliPay.selectedTitle = @"支付宝支付";
                _aliPay.titleFont = [UIFont systemFontOfSize:kWidth(22)];
                _aliPay.titleColor = [UIColor colorWithHexString:@"#ffffff"];
                [self addSubview:_aliPay];
                
                @weakify(self);
                _aliPay.action = ^ {
                    @strongify(self);
                    self.selectionAction([payDic[@"type"] unsignedIntegerValue],[payDic[@"subType"] unsignedIntegerValue]);
                    if (self->_aliPay.isSelected) {
                        return ;
                    } else if (self->_wxPay) {
                        self->_wxPay.isSelected = !self->_wxPay.isSelected;
                        self->_aliPay.isSelected = !self->_aliPay.isSelected;
                    }
                };
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
