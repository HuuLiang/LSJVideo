//
//  LSJPaymentConfigSummary.m
//  LSJVideo
//
//  Created by Liang on 16/9/13.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJPaymentConfigSummary.h"

NSString *const kLSJWeChatPayConfigName = @"WEIXIN";
NSString *const kLSJAlipayPayConfigName = @"ALIPAY";
NSString *const kLSJUnionPayConfigName = @"UNIONPAY";
NSString *const kLSJQQPayConfigName = @"QQPAY";

@implementation LSJPaymentConfigSummary

- (NSString *)LT_propertyOfParsing:(NSString *)parsingName {
    NSDictionary *mapping = @{kLSJWeChatPayConfigName:NSStringFromSelector(@selector(wechat)),
                              kLSJAlipayPayConfigName:NSStringFromSelector(@selector(alipay)),
                              kLSJUnionPayConfigName:NSStringFromSelector(@selector(unionpay)),
                              kLSJQQPayConfigName:NSStringFromSelector(@selector(qqpay))};
    return mapping[parsingName];
}

@end
