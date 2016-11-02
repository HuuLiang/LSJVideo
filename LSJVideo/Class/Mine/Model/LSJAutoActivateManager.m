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

static NSString *const kExchangeCodeURL = @"http://120.24.252.114/funmall/upexsts.service?";
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
    if (code.length != 10) {
        
    }
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *dataString = [NSString stringWithFormat:@"exchangeCode=%@&appId=%@", code, LSJ_REST_APPID];
    NSDictionary *params = @{@"data":[dataString encryptedStringWithPassword:[kExchangeCodeDataEncryptionPassword.md5 substringToIndex:16]]};
    
//    @weakify(self);
    [sessionManager POST:kExchangeCodeURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *encryptedData = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *dataString = [encryptedData decryptedStringWithPassword:[kExchangeCodeDataEncryptionPassword.md5 substringToIndex:16]];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        QBLog(@"Token request response: %@", dic);
        
        NSString *code = dic[@"code"];
        NSNumber *payPointType = dic[@"payPointType"];
        
        if ([code isEqualToString:@"200"]) {
//            [[LSJHudManager manager] showHudWithText:@"成功更新为已激活状态"];
            QBPaymentInfo *paymentInfo = [[QBPaymentInfo alloc] init];
            paymentInfo.payPointType = [payPointType unsignedIntegerValue];
            [[LSJPaymentViewController sharedPaymentVC] notifyPaymentResult:QBPayResultSuccess withPaymentInfo:paymentInfo];
        } else if ([code isEqualToString:@"2004"]) {
            [[LSJHudManager manager] showHudWithText:@"兑换码已激活"];
        } else if ([code isEqualToString:@"2003"]) {
            [[LSJHudManager manager] showHudWithText:@"兑换码不存在"];
        } else if ([code isEqualToString:@"2001"]) {
            [[LSJHudManager manager] showHudWithText:@"参数错误"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[LSJHudManager manager] showHudWithText:@"网络错误"];
    }];
}

@end
