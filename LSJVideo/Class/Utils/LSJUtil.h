//
//  LSJUtil.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSJPaymentInfo.h"

extern NSString *const kPaymentInfoKeyName;

@interface LSJUtil : NSObject

+ (NSString *)accessId;
+ (NSString *)userId;
+ (BOOL)isRegistered;
+ (void)setRegisteredWithUserId:(NSString *)userId;

+ (NSString *)deviceName;
+ (NSString *)appVersion;
+ (LSJDeviceType)deviceType;

+ (void)registerVip;
+ (BOOL)isVip;

+ (NSUInteger)launchSeq;
+ (void)accumateLaunchSeq;

+ (void)checkAppInstalledWithBundleId:(NSString *)bundleId completionHandler:(void (^)(BOOL))handler;

+ (NSArray<LSJPaymentInfo *> *)allPaymentInfos;
+ (NSArray<LSJPaymentInfo *> *)payingPaymentInfos;
+ (NSArray<LSJPaymentInfo *> *)paidNotProcessedPaymentInfos;
+ (LSJPaymentInfo *)successfulPaymentInfo;

+ (NSDate *)dateFromString:(NSString *)dateString;

+ (NSString *)currentTimeString;

+ (NSString *)paymentReservedData;

+ (UIViewController *)currentVisibleViewController;

+ (NSUInteger)currentTabPageIndex;
+ (NSUInteger)currentSubTabPageIndex;

@end
