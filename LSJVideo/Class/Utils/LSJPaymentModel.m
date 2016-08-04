//
//  LSJPaymentModel.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJPaymentModel.h"
#import "NSDictionary+LTSign.h"

static const NSTimeInterval kRetryingTimeInterval = 180;

static NSString *const kSignKey = @"qdge^%$#@(sdwHs^&";
static NSString *const kPaymentEncryptionPassword = @"wdnxs&*@#!*qb)*&qiang";

@interface LSJPaymentModel ()
@property (nonatomic,retain) NSTimer *retryingTimer;
@end

@implementation LSJPaymentModel
+ (instancetype)sharedModel {
    static LSJPaymentModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[LSJPaymentModel alloc] init];
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
                                   @"pV":LSJ_PAYMENT_PV };
    
    NSString *sign = [signParams signWithDictionary:[self class].commonParams keyOrders:[self class].keyOrdersOfCommonParams];
    NSString *encryptedDataString = [params encryptedStringWithSign:sign password:kPaymentEncryptionPassword excludeKeys:@[@"key"]];
    return @{@"data":encryptedDataString, @"appId":LSJ_REST_APPID};
}

- (void)startRetryingToCommitUnprocessedOrders {
    if (!self.retryingTimer) {
        @weakify(self);
        self.retryingTimer = [NSTimer bk_scheduledTimerWithTimeInterval:kRetryingTimeInterval block:^(NSTimer *timer) {
            @strongify(self);
            DLog(@"Payment: on retrying to commit unprocessed orders!");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [self commitUnprocessedOrders];
            });
        } repeats:YES];
    }
}

- (void)stopRetryingToCommitUnprocessedOrders {
    [self.retryingTimer invalidate];
    self.retryingTimer = nil;
}

//- (void)commitUnprocessedOrders {
//    NSArray<LTPaymentInfo *> *unprocessedPaymentInfos = [LTUtils paidNotProcessedPaymentInfos];
//    [unprocessedPaymentInfos enumerateObjectsUsingBlock:^(LTPaymentInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self commitPaymentInfo:obj];
//    }];
//}

- (BOOL)commitPaymentInfo:(LSJPaymentInfo *)paymentInfo {
    return [self commitPaymentInfo:paymentInfo withCompletionHandler:nil];
}

- (BOOL)commitPaymentInfo:(LSJPaymentInfo *)paymentInfo withCompletionHandler:(LSJCompletionHandler)handler {
    NSDictionary *statusDic = @{@(PAYRESULT_SUCCESS):@(1), @(PAYRESULT_FAIL):@(0), @(PAYRESULT_ABANDON):@(2), @(PAYRESULT_UNKNOWN):@(0)};
    
    if (nil == [LSJUtil userId] || paymentInfo.orderId.length == 0) {
        return NO;
    }
    
    NSDictionary *params = @{@"uuid":[LSJUtil userId],
                             @"orderNo":paymentInfo.orderId,
                             @"imsi":@"999999999999999",
                             @"imei":@"999999999999999",
                             @"payMoney":paymentInfo.orderPrice.stringValue,
                             @"channelNo":LSJ_CHANNEL_NO,
                             @"contentId":paymentInfo.contentId.stringValue ?: @"0",
                             @"contentType":paymentInfo.contentType.stringValue ?: @"0",
                             @"pluginType":paymentInfo.paymentType,
                             @"payPointType":paymentInfo.payPointType ?: @"1",
                             @"appId":LSJ_REST_APPID,
                             @"versionNo":@([LSJUtil appVersion].integerValue),
                             @"status":statusDic[paymentInfo.paymentResult],
                             @"pV":LSJ_PAYMENT_PV,
                             @"payTime":paymentInfo.paymentTime};
    
    BOOL success = [super requestURLPath:LSJ_PAYMENT_COMMIT_URL
                              withParams:params
                         responseHandler:^(LSJURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        if (respStatus == LSJURLResponseSuccess) {
                            paymentInfo.paymentStatus = @(LSJPaymentStatusProcessed);
                        } else {
                            DLog(@"Payment: fails to commit the order with orderId:%@", paymentInfo.orderId);
                        }
                        
                        if (handler) {
                            handler(respStatus == LSJURLResponseSuccess, errorMessage);
                        }
                    }];
    return success;
}
@end
