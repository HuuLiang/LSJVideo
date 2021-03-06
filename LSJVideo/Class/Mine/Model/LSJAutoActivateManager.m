//
//  LSJAutoActivateManager.m
//  LSJVideo
//
//  Created by Liang on 2016/11/2.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJAutoActivateManager.h"
#import <AFNetworking.h>
#import <NSDate+Utilities.h>
#import "LSJPaymentViewController.h"

static NSString *const kExchangeCodeURL = @"http://funmall.iqu8.cn/funmall/upexsts.service";
static NSString *const kExchangeCodeDataEncryptionPassword = @"qb%Fm@2016_&";

@implementation LSJAutoActivateManager

+ (instancetype)sharedManager {
    static LSJAutoActivateManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)requestExchangeCode:(NSString *)code{
    if (code == 0) {
        [[LSJHudManager manager] showHudWithText:@"参数错误"];
    }
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSDictionary *params = @{@"exchangeCode":code,
                             @"appId":LSJ_REST_APPID};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    if (!jsonData) {
        
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *encryptedDataString = [jsonString encryptedStringWithPassword:[kExchangeCodeDataEncryptionPassword.md5 substringToIndex:16]];
    NSDictionary *dataParams = @{@"data":encryptedDataString};
    
    [sessionManager POST:kExchangeCodeURL parameters:dataParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *encryptedData = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[encryptedData dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        QBLog(@"Token request response: %@", dic);
        
        NSInteger code = [dic[@"code"] integerValue];
        NSString *payPointType = dic[@"payPointType"];
        
        if (code == 200) {
            QBPaymentInfo *paymentInfo = [[QBPaymentInfo alloc] init];
            paymentInfo.payPointType = [payPointType integerValue];
            [[LSJPaymentViewController sharedPaymentVC] notifyPaymentResult:QBPayResultSuccess withPaymentInfo:paymentInfo];
        } else if (code == 2004) {
            [[LSJHudManager manager] showHudWithText:@"兑换码已激活"];
        } else if (code == 2003) {
            [[LSJHudManager manager] showHudWithText:@"兑换码不存在"];
        } else if (code == 2001) {
            [[LSJHudManager manager] showHudWithText:@"参数错误"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[LSJHudManager manager] showHudWithText:@"网络错误"];
    }];
}

@end
