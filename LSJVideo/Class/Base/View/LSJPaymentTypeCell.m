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

- (instancetype)initWithPaymentType:(QBPayType)paymentType subType:(QBPaySubType)subType
{
    self = [super init];
    if (self) {
        self.payType = paymentType;
        self.subType = subType;
        
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

@end
