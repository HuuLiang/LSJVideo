//
//  LSJPaymentConfigModel.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJPaymentConfigModel.h"

static NSString *const kSignKey = @"qdge^%$#@(sdwHs^&";
static NSString *const kPaymentEncryptionPassword = @"wdnxs&*@#!*qb)*&qiang";

@implementation LSJPaymentConfigModel

+ (Class)responseClass {
    return [LSJPaymentConfig class];
}

+ (instancetype)sharedModel {
    static LSJPaymentConfigModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

- (NSURL *)baseURL {
    return nil;
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (LSJURLRequestMethod)requestMethod {
    return LSJURLPostRequest;
}

+ (NSString *)signKey {
    return kSignKey;
}

- (NSDictionary *)encryptWithParams:(NSDictionary *)params {
    NSDictionary *signParams = @{  @"appId":LSJ_REST_APPID,
                                   @"key":kSignKey,
                                   @"imsi":@"999999999999999",
                                   @"channelNo":LSJ_CHANNEL_NO,
                                   @"pv":LSJ_PAYMENT_PV };
    
    NSString *sign = [signParams signWithDictionary:[self class].commonParams keyOrders:[self class].keyOrdersOfCommonParams];
    NSString *encryptedDataString = [params encryptedStringWithSign:sign password:kPaymentEncryptionPassword excludeKeys:@[@"key"]];
    return @{@"data":encryptedDataString, @"appId":LSJ_REST_APPID};
}

- (BOOL)fetchPaymentConfigInfoWithCompletionHandler:(LSJCompletionHandler)handler {
    @weakify(self);
    BOOL ret = [self requestURLPath:LSJ_PAYMENT_CONFIG_URL
                     standbyURLPath:[NSString stringWithFormat:LSJ_STANDBY_PAYMENT_CONFIG_URL, LSJ_REST_APPID]
                         withParams:@{@"appId":LSJ_REST_APPID, @"channelNo":LSJ_CHANNEL_NO, @"pv":LSJ_PAYMENT_PV}
                    responseHandler:^(LSJURLResponseStatus respStatus, NSString *errorMessage)
                {
                    @strongify(self);
                    if (!self) {
                        return ;
                    }
                    
                    LSJPaymentConfig *config;
                    if (respStatus == LSJURLResponseSuccess) {
                        self->_loaded = YES;
                        
                        config = self.response;
                        [config setAsCurrentConfig];
                        DLog("%@",[LSJPaymentConfig sharedConfig]);
                        
                        
                        DLog(@"Payment config loaded!");
                    }
                    
                    if (handler) {
                        handler(respStatus == LSJURLResponseSuccess, config);
                    }
                }];
    return ret;
}
@end
