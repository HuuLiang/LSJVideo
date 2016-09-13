//
//  LSJPaymentInfo.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJPaymentInfo.h"

#import "NSMutableDictionary+Safety.h"

static NSString *const kPaymentInfoPaymentIdKeyName = @"LSJVideo_paymentinfo_paymentid_keyname";
static NSString *const kPaymentInfoOrderIdKeyName = @"LSJVideo_paymentinfo_orderid_keyname";
static NSString *const kPaymentInfoOrderPriceKeyName = @"LSJVideo_paymentinfo_orderprice_keyname";
static NSString *const kPaymentInfoContentIdKeyName = @"LSJVideo_paymentinfo_contentid_keyname";
static NSString *const kPaymentInfoContentTypeKeyName = @"LSJVideo_paymentinfo_contenttype_keyname";
static NSString *const kPaymentInfoPayPointTypeKeyName = @"LSJVideo_paymentinfo_paypointtype_keyname";
static NSString *const kPaymentInfoPaymentTypeKeyName = @"LSJVideo_paymentinfo_paymenttype_keyname";
static NSString *const kPaymentInfoPaymentResultKeyName = @"LSJVideo_paymentinfo_paymentresult_keyname";
static NSString *const kPaymentInfoPaymentStatusKeyName = @"LSJVideo_paymentinfo_paymentstatus_keyname";
static NSString *const kPaymentInfoPaymentTimeKeyName = @"LSJVideo_paymentinfo_paymenttime_keyname";
static NSString *const kPaymentInfoPaymentReservedDataKeyName = @"LSJVideo_paymentinfo_paymentreserveddata_keyname";

static NSString *const kPaymentInfoPaymentAppId = @"LSJVideo_paymentinfo_paymentappid_keyname";
static NSString *const kPaymentInfoPaymentMchId = @"LSJVideo_paymentinfo_paymentmchid_keyname";
static NSString *const kPaymentInfoPaymentSignKey = @"LSJVideo_paymentinfo_paymentsignkey_keyname";
static NSString *const kPaymentInfoPaymentNotifyUrl = @"LSJVideo_paymentinfo_paymentnotifyurl_keyname";

static NSString *const kPaymentInfoPaymentColumIdKey = @"LSJkuaibov_paymentinfo_paymentcolunidkey_keyname";
static NSString *const kPaymentInfoPaymentColumTypeKey = @"LSJkuaibov_paymentinfo_paymentcoluntypekey_keyname";
static NSString *const kPaymentInfoPaymentContentLocationKey = @"LSJkuaibov_paymentinfo_paymentcontentlocationkey_keyname";

@implementation LSJPaymentInfo

- (NSString *)paymentId {
    if (_paymentId) {
        return _paymentId;
    }
    
    _paymentId = [NSUUID UUID].UUIDString.md5;
    return _paymentId;
}

+ (instancetype)paymentInfoFromDictionary:(NSDictionary *)payment {
    LSJPaymentInfo *paymentInfo = [[self alloc] init];
    paymentInfo.paymentId = payment[kPaymentInfoPaymentIdKeyName];
    paymentInfo.orderId = payment[kPaymentInfoOrderIdKeyName];
    paymentInfo.orderPrice = payment[kPaymentInfoOrderPriceKeyName];
    paymentInfo.contentId = payment[kPaymentInfoContentIdKeyName];
    paymentInfo.contentType = payment[kPaymentInfoContentTypeKeyName];
    paymentInfo.payPointType = payment[kPaymentInfoPayPointTypeKeyName];
    paymentInfo.paymentType = payment[kPaymentInfoPaymentTypeKeyName];
    paymentInfo.paymentResult = payment[kPaymentInfoPaymentResultKeyName];
    paymentInfo.paymentStatus = payment[kPaymentInfoPaymentStatusKeyName];
    paymentInfo.paymentTime = payment[kPaymentInfoPaymentTimeKeyName];
    paymentInfo.reservedData = payment[kPaymentInfoPaymentReservedDataKeyName];
    paymentInfo.appId = payment[kPaymentInfoPaymentAppId];
    paymentInfo.mchId = payment[kPaymentInfoPaymentMchId];
    paymentInfo.notifyUrl = payment[kPaymentInfoPaymentNotifyUrl];
    paymentInfo.signKey = payment[kPaymentInfoPaymentSignKey];
    paymentInfo.columnId = payment[kPaymentInfoPaymentColumIdKey];
    paymentInfo.columnType = payment[kPaymentInfoPaymentColumTypeKey];
    paymentInfo.contentLocation = payment[kPaymentInfoPaymentContentLocationKey];
    return paymentInfo;
}

- (NSDictionary *)dictionaryFromCurrentPaymentInfo {
    NSMutableDictionary *payment = [NSMutableDictionary dictionary];
    [payment safelySetObject:self.paymentId forKey:kPaymentInfoPaymentIdKeyName];
    [payment safelySetObject:self.orderId forKey:kPaymentInfoOrderIdKeyName];
    [payment safelySetObject:self.orderPrice forKey:kPaymentInfoOrderPriceKeyName];
    [payment safelySetObject:self.contentId forKey:kPaymentInfoContentIdKeyName];
    [payment safelySetObject:self.contentType forKey:kPaymentInfoContentTypeKeyName];
    [payment safelySetObject:self.payPointType forKey:kPaymentInfoPayPointTypeKeyName];
    [payment safelySetObject:self.paymentType forKey:kPaymentInfoPaymentTypeKeyName];
    [payment safelySetObject:self.paymentResult forKey:kPaymentInfoPaymentResultKeyName];
    [payment safelySetObject:self.paymentStatus forKey:kPaymentInfoPaymentStatusKeyName];
    [payment safelySetObject:self.paymentTime forKey:kPaymentInfoPaymentTimeKeyName];
    [payment safelySetObject:self.reservedData forKey:kPaymentInfoPaymentReservedDataKeyName];
    [payment safelySetObject:self.appId forKey:kPaymentInfoPaymentAppId];
    [payment safelySetObject:self.mchId forKey:kPaymentInfoPaymentMchId];
    [payment safelySetObject:self.notifyUrl forKey:kPaymentInfoPaymentNotifyUrl];
    [payment safelySetObject:self.signKey forKey:kPaymentInfoPaymentSignKey];
    
    [payment safelySetObject:self.columnId forKey:kPaymentInfoPaymentColumIdKey];
    [payment safelySetObject:self.columnType forKey:kPaymentInfoPaymentColumTypeKey];
    [payment safelySetObject:self.contentLocation forKey:kPaymentInfoPaymentContentLocationKey];
    return payment;
}

- (void)save {
    NSArray *paymentInfos = [[NSUserDefaults standardUserDefaults] objectForKey:kPaymentInfoKeyName];
    
    NSMutableArray *paymentInfosM = [paymentInfos mutableCopy];
    if (!paymentInfosM) {
        paymentInfosM = [NSMutableArray array];
    }
    
    NSDictionary *payment = [paymentInfos bk_match:^BOOL(id obj) {
        NSString *paymentId = ((NSDictionary *)obj)[kPaymentInfoPaymentIdKeyName];
        if ([paymentId isEqualToString:self.paymentId]) {
            return YES;
        }
        return NO;
    }];
    
    if (payment) {
        [paymentInfosM removeObject:payment];
    }
    
    payment = [self dictionaryFromCurrentPaymentInfo];
    [paymentInfosM addObject:payment];
    
    [[NSUserDefaults standardUserDefaults] setObject:paymentInfosM forKey:kPaymentInfoKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    DLog(@"Save payment info: %@", payment);
}

@end
