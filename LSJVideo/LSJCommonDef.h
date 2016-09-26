//
//  LSJCommonDef.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#ifndef LSJCommonDef_h
#define LSJCommonDef_h

typedef NS_ENUM(NSUInteger, LSJPaymentPopViewSection) {
    HeaderSection,
    PayPointSection,
    PaymentTypeSection,
//    PaySection,
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

typedef NS_ENUM(NSUInteger ,LSJVipLevel) {
    LSJVipLevelNone,
    LSJVipLevelVip,
    LSJVipLevelSVip
};


#define kDefaultTextColor [UIColor colorWithWhite:0.5 alpha:1]
#define kDefaultBackgroundColor [UIColor colorWithWhite:0.97 alpha:1]
#define kDefaultPhotoBlurRadius (5)
#define kThemeColor     [UIColor colorWithHexString:@"#ff6666"]
#define kDefaultDateFormat   @"yyyyMMddHHmmss"

#define KUSERPHOTOURL @"kUerPhtotUrlKeyName"

#define kPaidNotificationName @"LSJ_paid_notification"

#define kWidth(width)   kScreenWidth  * width  / 750
#define kHeight(height) kScreenHeight * height / 1334.


#define LSJ_VIP         @"IS_LSJ_VIP"
#define LSJ_SVIP        @"IS_LSJ_SVIP"

typedef void (^LSJSelectionAction)(QBPayType payType,QBPaySubType subType);
typedef void (^LSJProgressHandler)(double progress);


#define LSJ_SYSTEM_CONTACT_NAME     @"CONTACT_NAME"
#define LSJ_SYSTEM_CONTACT_SCHEME   @"CONTACT_SCHEME"
#define LSJ_SYSTEM_MINE_IMG                @"MINE_IMG"
#define LSJ_SYSTEM_PAY_AMOUNT              @"PAY_AMOUNT"
#define LSJ_SYSTEM_SVIP_PAY_AMOUNT         @"SVIP_PAY_AMOUNT"
#define LSJ_SYSTEM_PAY_IMG                 @"PAY_IMG"
#define LSJ_SYSTEM_SVIP_PAY_IMG            @"SVIP_PAY_IMG"
#define LSJ_SYSTEM_IMAGE_TOKEN             @"IMG_REFERER"


#endif /* LSJCommonDef_h */
