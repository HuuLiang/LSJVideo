//
//  LSJPaymentConfig.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJURLResponse.h"

//typedef NS_ENUM(NSUInteger, LSJSubPayType) {
//    LSJSubPayTypeUnknown = 0,
//    LSJSubPayTypeWeChat = 1 << 0,
//    LSJSubPayTypeAlipay = 1 << 1
//};

@interface LSJWeChatPaymentConfig : NSObject
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *signKey;
@property (nonatomic) NSString *notifyUrl;

//+ (instancetype)defaultConfig;
@end

@interface LSJAlipayConfig : NSObject
@property (nonatomic) NSString *partner;
@property (nonatomic) NSString *seller;
@property (nonatomic) NSString *productInfo;
@property (nonatomic) NSString *privateKey;
@property (nonatomic) NSString *notifyUrl;
@end

@interface LSJIAppPayConfig : NSObject
@property (nonatomic) NSString *appid;
@property (nonatomic) NSString *privateKey;
@property (nonatomic) NSString *publicKey;
@property (nonatomic) NSString *notifyUrl;
@property (nonatomic) NSNumber *waresid;
@property (nonatomic) NSNumber *supportPayTypes;

//+ (instancetype)defaultConfig;
@end

@interface LSJVIAPayConfig : NSObject

//@property (nonatomic) NSString *packageId;
@property (nonatomic) NSNumber *supportPayTypes;

@end

@interface LSJSPayConfig : NSObject
@property (nonatomic) NSString *signKey;
@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *notifyUrl;
@end

@interface LSJHTPayConfig : NSObject
@property (nonatomic) NSString *key;
@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *notifyUrl;
@end

@interface LSJPaymentConfig : LSJURLResponse

@property (nonatomic,retain) LSJWeChatPaymentConfig *weixinInfo;
@property (nonatomic,retain) LSJAlipayConfig *alipayInfo;
@property (nonatomic,retain) LSJIAppPayConfig *iappPayInfo;
@property (nonatomic,retain) LSJVIAPayConfig *syskPayInfo;
@property (nonatomic,retain) LSJSPayConfig *wftPayInfo;
@property (nonatomic,retain) LSJHTPayConfig *haitunPayInfo;

+ (instancetype)sharedConfig;
- (void)setAsCurrentConfig;
@end
