//
//  LSJPaymentConfigSummary.h
//  LSJVideo
//
//  Created by Liang on 16/9/13.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSJURLResponse.h"

extern NSString *const kLSJWeChatPayConfigName;
extern NSString *const kLSJAlipayPayConfigName;
extern NSString *const kLSJUnionPayConfigName;
extern NSString *const kLSJQQPayConfigName;

@interface LSJPaymentConfigSummary : NSObject <LSJResponseParsable>

@property (nonatomic) NSString *wechat;
@property (nonatomic) NSString *alipay;
@property (nonatomic) NSString *unionpay;
@property (nonatomic) NSString *qqpay;


@end
