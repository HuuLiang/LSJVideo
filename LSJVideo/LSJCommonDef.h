//
//  LSJCommonDef.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#ifndef LSJCommonDef_h
#define LSJCommonDef_h

#ifdef  DEBUG
#define DLog(fmt,...) {NSLog((@"%s [Line:%d]" fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__);}
#else
#define DLog(...)
#endif


typedef NS_ENUM(NSUInteger, LSJPaymentType) {
    LSJPaymentTypeNone,
    LSJPaymentTypeAlipay = 1001,
    LSJPaymentTypeWeChatPay = 1008,
    LSJPaymentTypeIAppPay = 1009,
    LSJPaymentTypeVIAPay = 1010,
    LSJPaymentTypeSPay = 1012,
    LSJPaymentTypeHTPay = 1015
};
typedef NS_ENUM(NSUInteger, LSJSubPayType) {
    LSJSubPayTypeNone = 0,
    LSJSubPayTypeWeChat = 1 << 0,
    LSJSubPayTypeAlipay = 1 << 1,
    LSJSubPayUPPay = 1 << 2,
    LSJSubPayTypeQQ = 1 << 3
};

typedef NS_ENUM(NSInteger, PAYRESULT)
{
    PAYRESULT_SUCCESS   = 0,
    PAYRESULT_FAIL      = 1,
    PAYRESULT_ABANDON   = 2,
    PAYRESULT_UNKNOWN   = 3
};

typedef NS_ENUM(NSUInteger, LSJPaymentPopViewSection) {
    HeaderSection,
    PayPointSection,
    PaymentTypeSection,
    PaySection,
    SectionCount
};

typedef NS_ENUM(NSUInteger, LSJDeviceType) {
    LSJDeviceTypeUnknown,
    LSJDeviceType_iPhone4,
    LSJDeviceType_iPhone4S,
    LSJDeviceType_iPhone5,
    LSJDeviceType_iPhone5C,
    LSJDeviceType_iPhone5S,
    LSJDeviceType_iPhone6,
    LSJDeviceType_iPhone6P,
    LSJDeviceType_iPhone6S,
    LSJDeviceType_iPhone6SP,
    LSJDeviceType_iPhoneSE,
    LSJDeviceType_iPad = 100
};


#define DefineLazyPropertyInitialization(propertyType, propertyName) \
-(propertyType *)propertyName { \
if (_##propertyName) { \
return _##propertyName; \
} \
_##propertyName = [[propertyType alloc] init]; \
return _##propertyName; \
}

#define SafelyCallBlock(block) if (block) block();
#define SafelyCallBlock1(block, arg) if (block) block(arg);
#define SafelyCallBlock2(block, arg1, arg2) if (block) block(arg1, arg2);
#define SafelyCallBlock3(block, arg1, arg2, arg3) if (block) block(arg1, arg2, arg3);
#define SafelyCallBlock4(block,...) \
if (block) block(__VA_ARGS__);


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [[UIScreen mainScreen]bounds].size.height

#define kDefaultTextColor [UIColor colorWithWhite:0.5 alpha:1]
#define kDefaultBackgroundColor [UIColor colorWithWhite:0.97 alpha:1]
#define kDefaultPhotoBlurRadius (5)
#define kThemeColor     [UIColor colorWithHexString:@"#ff6666"]
#define kDefaultDateFormat   @"yyyyMMddHHmmss"

#define KUSERPHOTOURL @"kUerPhtotUrlKeyName"

#define kPaidNotificationName @"LSJ_paid_notification"

#define kWidth(width)   kScreenWidth  * width  / 750
#define kHeight(height) kScreenHeight * height / 1334.


#define IS_VIP         @"is_LSJ_vip"

typedef void (^LSJAction)(id obj);
typedef void (^LSJSelectionAction)(LSJPaymentType paymentType);
typedef void (^LSJProgressHandler)(double progress);
typedef void (^LSJCompletionHandler)(BOOL success, id obj);


@class LSJPaymentInfo;
typedef void (^LSJPaymentCompletionHandler)(PAYRESULT payResult, LSJPaymentInfo *paymentInfo);

//#define kBigFont  [UIFont systemFontOfSize:MIN(18,kScreenWidth*0.05)]
//#define kMediumFont [UIFont systemFontOfSize:MIN(16, kScreenWidth*0.045)]
//#define kSmallFont [UIFont systemFontOfSize:MIN(14, kScreenWidth*0.04)]
//#define kExtraSmallFont [UIFont systemFontOfSize:MIN(12, kScreenWidth*0.035)]

#endif /* LSJCommonDef_h */
