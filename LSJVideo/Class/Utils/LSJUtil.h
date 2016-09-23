//
//  LSJUtil.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBPaymentInfo.h"

extern NSString *const kPaymentInfoKeyName;

@interface LSJUtil : NSObject

+ (NSString *)accessId;
+ (NSString *)userId;
+ (BOOL)isRegistered;
+ (void)setRegisteredWithUserId:(NSString *)userId;

+ (NSString *)deviceName;
+ (NSString *)appVersion;
+ (LSJDeviceType)deviceType;

+ (BOOL)isIpad;

+ (void)registerVip;
+ (void)registerSVip;
+ (BOOL)isVip;
+ (BOOL)isSVip;
+ (LSJVipLevel)currentVipLevel;

+ (NSUInteger)launchSeq;
+ (void)accumateLaunchSeq;

+ (void)checkAppInstalledWithBundleId:(NSString *)bundleId completionHandler:(void (^)(BOOL))handler;

+ (NSArray<QBPaymentInfo *> *)allPaymentInfos;
+ (NSArray<QBPaymentInfo *> *)payingPaymentInfos;
+ (NSArray<QBPaymentInfo *> *)paidNotProcessedPaymentInfos;
+ (QBPaymentInfo *)successfulPaymentInfo;

+ (NSDate *)dateFromString:(NSString *)dateString;

+ (NSString *)currentTimeString;

+ (NSString *)paymentReservedData;

+ (UIViewController *)currentVisibleViewController;

+ (NSUInteger)currentTabPageIndex;
+ (NSUInteger)currentSubTabPageIndex;

@end
