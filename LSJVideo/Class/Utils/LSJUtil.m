//
//  LSJUtil.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJUtil.h"
#import <SFHFKeychainUtils.h>
#import <sys/sysctl.h>
#import "NSDate+Utilities.h"
#import "JQKApplicationManager.h"
#import "LSJBaseViewController.h"

NSString *const kPaymentInfoKeyName             = @"LSJ_paymentinfo_keyname";

static NSString *const kLaunchSeqKeyName        = @"LSJ_launchseq_keyname";
static NSString *const kRegisterKeyName         = @"LSJ_register_keyname";
static NSString *const kUserAccessUsername      = @"LSJ_user_access_username";
static NSString *const kUserAccessServicename   = @"LSJ_user_access_service";

static NSString *const kVipUserKeyName          = @"LSJ_Vip_UserKey";
static NSString *const kSVipUserKeyName         = @"LSJ_SVip_UserKey";

@implementation LSJUtil

+ (NSString *)accessId {
    NSString *accessIdInKeyChain = [SFHFKeychainUtils getPasswordForUsername:kUserAccessUsername andServiceName:kUserAccessServicename error:nil];
    if (accessIdInKeyChain) {
        return accessIdInKeyChain;
    }
    
    accessIdInKeyChain = [NSUUID UUID].UUIDString.md5;
    [SFHFKeychainUtils storeUsername:kUserAccessUsername andPassword:accessIdInKeyChain forServiceName:kUserAccessServicename updateExisting:YES error:nil];
    return accessIdInKeyChain;
}

+ (NSString *)userId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRegisterKeyName];
}

+ (BOOL)isRegistered {
    return [self userId] != nil;
}

+ (void)setRegisteredWithUserId:(NSString *)userId {
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kRegisterKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)deviceName {
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *name = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return name;
}

+ (LSJDeviceType)deviceType {
    NSString *deviceName = [self deviceName];
    if ([deviceName rangeOfString:@"iPhone3,"].location == 0) {
        return LSJDeviceType_iPhone4;
    } else if ([deviceName rangeOfString:@"iPhone4,"].location == 0) {
        return LSJDeviceType_iPhone4S;
    } else if ([deviceName rangeOfString:@"iPhone5,1"].location == 0 || [deviceName rangeOfString:@"iPhone5,2"].location == 0) {
        return LSJDeviceType_iPhone5;
    } else if ([deviceName rangeOfString:@"iPhone5,3"].location == 0 || [deviceName rangeOfString:@"iPhone5,4"].location == 0) {
        return LSJDeviceType_iPhone5C;
    } else if ([deviceName rangeOfString:@"iPhone6,"].location == 0) {
        return LSJDeviceType_iPhone5S;
    } else if ([deviceName rangeOfString:@"iPhone7,1"].location == 0) {
        return LSJDeviceType_iPhone6P;
    } else if ([deviceName rangeOfString:@"iPhone7,2"].location == 0) {
        return LSJDeviceType_iPhone6;
    } else if ([deviceName rangeOfString:@"iPhone8,1"].location == 0) {
        return LSJDeviceType_iPhone6S;
    } else if ([deviceName rangeOfString:@"iPhone8,2"].location == 0) {
        return LSJDeviceType_iPhone6SP;
    } else if ([deviceName rangeOfString:@"iPhone8,4"].location == 0) {
        return LSJDeviceType_iPhoneSE;
    } else if ([deviceName rangeOfString:@"iPad"].location == 0) {
        return LSJDeviceType_iPad;
    } else {
        return LSJDeviceTypeUnknown;
    }
}

+ (BOOL)isIpad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (NSString *)appVersion {
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
}

+ (void)registerVip {
    [[NSUserDefaults standardUserDefaults] setObject:LSJ_VIP forKey:kVipUserKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)registerSVip {
    [[NSUserDefaults standardUserDefaults] setObject:LSJ_SVIP forKey:kSVipUserKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isVip {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kVipUserKeyName] isEqualToString:LSJ_VIP];
}

+ (BOOL)isSVip {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kSVipUserKeyName] isEqualToString:LSJ_SVIP];
}

+ (LSJVipLevel)currentVipLevel {
    if ([self isSVip]) {
        return LSJVipLevelSVip;
    } else if (![self isSVip] && [self isVip]) {
        return LSJVipLevelVip;
    } else {
        return LSJVipLevelNone;
    }
}


+ (NSUInteger)launchSeq {
    NSNumber *launchSeq = [[NSUserDefaults standardUserDefaults] objectForKey:kLaunchSeqKeyName];
    return launchSeq.unsignedIntegerValue;
}

+ (void)accumateLaunchSeq {
    NSUInteger launchSeq = [self launchSeq];
    [[NSUserDefaults standardUserDefaults] setObject:@(launchSeq+1) forKey:kLaunchSeqKeyName];
}

+ (void)checkAppInstalledWithBundleId:(NSString *)bundleId completionHandler:(void (^)(BOOL))handler {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL installed = [[[JQKApplicationManager defaultManager] allInstalledAppIdentifiers] bk_any:^BOOL(id obj) {
            return [bundleId isEqualToString:obj];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler(installed);
            }
        });
    });
}

+ (NSArray<QBPaymentInfo *> *)allPaymentInfos {
//    NSArray<NSDictionary *> *paymentInfoArr = [[NSUserDefaults standardUserDefaults] objectForKey:kPaymentInfoKeyName];
//    
//    NSMutableArray *paymentInfos = [NSMutableArray array];
//    [paymentInfoArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        QBPaymentInfo *paymentInfo = [QBPaymentInfo paymentInfoFromDictionary:obj];
//        [paymentInfos addObject:paymentInfo];
//    }];
    return [QBPaymentInfo allPaymentInfos];
}

+ (NSArray<QBPaymentInfo *> *)payingPaymentInfos {
    return [self.allPaymentInfos bk_select:^BOOL(id obj) {
        QBPaymentInfo *paymentInfo = obj;
        return paymentInfo.paymentStatus == QBPayStatusPaying;
    }];
}

+ (NSArray<QBPaymentInfo *> *)paidNotProcessedPaymentInfos {
    return [self.allPaymentInfos bk_select:^BOOL(id obj) {
        QBPaymentInfo *paymentInfo = obj;
        return paymentInfo.paymentStatus == QBPayStatusNotProcessed;
    }];
}

+ (QBPaymentInfo *)successfulPaymentInfo {
    return [self.allPaymentInfos bk_match:^BOOL(id obj) {
        QBPaymentInfo *paymentInfo = obj;
        if (paymentInfo.paymentResult == QBPayResultSuccess) {
            return YES;
        }
        return NO;
    }];
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)currentTimeString {
    NSDateFormatter *fomatter =[[NSDateFormatter alloc] init];
    [fomatter setDateFormat:kDefaultDateFormat];
    return [fomatter stringFromDate:[NSDate date]];
}

+ (NSString *)paymentReservedData {
    return [NSString stringWithFormat:@"%@$%@", LSJ_REST_APPID, LSJ_CHANNEL_NO];
}

+ (UIViewController *)currentVisibleViewController {
    UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *selectedVC = tabBarController.selectedViewController;
    if ([selectedVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController *)selectedVC;
        return navVC.visibleViewController;
    }
    return selectedVC;
}

+ (NSUInteger)currentTabPageIndex {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabVC = (UITabBarController *)rootVC;
        return tabVC.selectedIndex;
    }
    return 0;
}

+ (NSUInteger)currentSubTabPageIndex {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabVC = (UITabBarController *)rootVC;
        if ([tabVC.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navVC = (UINavigationController *)tabVC.selectedViewController;
            if ([navVC.visibleViewController isKindOfClass:[LSJBaseViewController class]]) {
                return NSIntegerMax;
            }
        }
    }
    return NSNotFound;
}

@end
