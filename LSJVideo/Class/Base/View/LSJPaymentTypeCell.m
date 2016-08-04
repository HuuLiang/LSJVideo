//
//  LSJPaymentTypeCell.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJPaymentTypeCell.h"
@interface LSJPaymentTypeCell ()
{
    UIImageView *_imgV;
    UILabel *_label;
}
@end

@implementation LSJPaymentTypeCell

- (instancetype)initWithPaymentType:(LSJPaymentType)paymentType subType:(LSJSubPayType)subType
{
    self = [super init];
    if (self) {
        self.payType = paymentType;
        self.subType = subType;
        
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _chooseBtn.layer.cornerRadius = 20;
        _chooseBtn.layer.masksToBounds = YES;
        [_chooseBtn setImage:[UIImage imageNamed:@"choose_normal"] forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"choose_selected"] forState:UIControlStateSelected];
        [self addSubview:_chooseBtn];
        
        [_chooseBtn bk_addEventHandler:^(id sender) {
            _selectionAction(paymentType);
        } forControlEvents:UIControlEventTouchUpInside];
        
        NSString *imageName = @"";
        NSString *text = @"";
        NSString *subTitle = nil;
        if (paymentType == LSJPaymentTypeVIAPay && subType == LSJSubPayTypeAlipay) {
            imageName = @"alipay_icon";
            text = @"支付宝支付";
        }
        if(paymentType == LSJPaymentTypeVIAPay && subType == LSJSubPayTypeWeChat){
            imageName = @"wechat_icon";
            text = @"微信支付";
        }
        if (paymentType == LSJPaymentTypeIAppPay){
            imageName = @"card_pay_icon";
            text = @"购卡支付";
            subTitle = @"支持支付宝和微信";
        }
        if (paymentType == LSJPaymentTypeVIAPay && subType == LSJSubPayTypeQQ){
            imageName = @"qq_icon";
            text = @"QQ钱包";
        }
        
        _imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [self addSubview:_imgV];
        
        _label = [[UILabel alloc] init];
        _label.text = text;//LSJPaymentTypeAlipay == paymentType ? @"支付宝支付" : @"微信支付";
        _label.textColor = [UIColor colorWithHexString:@"#333333"];
        _label.font = [UIFont systemFontOfSize:14.];
        _label.backgroundColor = [UIColor clearColor];
        [self addSubview:_label];
        
        UILabel *subLabel = [[UILabel alloc] init];
        subLabel.textColor = [UIColor lightGrayColor];
        subLabel.font = [UIFont systemFontOfSize:10.];
        subLabel.backgroundColor = [UIColor clearColor];
        subLabel.text = subTitle;
        [self addSubview: subLabel];
        
        {
            [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(10);
                make.size.mas_equalTo(CGSizeMake(40, 40));
            }];
            
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(_chooseBtn.mas_right).offset(5);
                make.size.mas_equalTo(CGSizeMake(25, 25));
            }];
            
            CGFloat offsetH = 0;
            //            CGFloat labelHeight = 0.;
            if (subTitle != nil) {
                offsetH = -5.;
                //                labelHeight = 10.;
            }
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self).mas_offset(offsetH);
                make.left.equalTo(_imgV.mas_right).offset(10);
                make.right.equalTo(self);
                make.height.mas_equalTo(20);
            }];
            
            [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_label).mas_offset(-0.5);
                make.top.mas_equalTo(_label.mas_bottom);
                //                make.height.mas_equalTo(labelHeight);
            }];
        }
    }
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    _chooseBtn.selected = selected;
}
@end
