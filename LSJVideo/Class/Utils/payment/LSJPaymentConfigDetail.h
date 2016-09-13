//
//  LSJPaymentConfigDetail.h
//  LSJVideo
//
//  Created by Liang on 16/9/13.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSJURLResponse.h"

@class LSJIAppPayConfig;
@class LSJVIAPayConfig;
@class LSJMingPayConfig;
@class LSJSPayConfig;
@class LSJHTPayConfig;
@class LSJWeiYingPayConfig;
@class LSJDXTXPayConfig;

extern NSString *const kLSJIAppPayConfigName;
extern NSString *const kLSJVIAPayConfigName;
extern NSString *const kLSJMingPayConfigName;
extern NSString *const kLSJSPayConfigName;
extern NSString *const kLSJHTPayConfigName;
extern NSString *const kLSJWeiYingConfigName;
extern NSString *const kLSJDXTXPayConfigName;

@interface LSJPaymentConfigDetail : NSObject <LSJResponseParsable>

@property (nonatomic,retain) LSJIAppPayConfig *iAppPayConfig; //爱贝支付
@property (nonatomic,retain) LSJVIAPayConfig *viaPayConfig; //首游时空
@property (nonatomic,retain) LSJMingPayConfig *mingPayConfig; //明鹏支付
@property (nonatomic,retain) LSJSPayConfig *spayConfig; //威富通
@property (nonatomic,retain) LSJHTPayConfig *haitunConfig;//海豚支付
@property (nonatomic,retain) LSJWeiYingPayConfig *weiYingPayConfig; //微赢支付
@property (nonatomic,retain) LSJDXTXPayConfig *dxtxPayConfig; //盾行天下
@end

@interface LSJIAppPayConfig : NSObject
@property (nonatomic) NSString *appid;
@property (nonatomic) NSString *privateKey;
@property (nonatomic) NSString *publicKey;
@property (nonatomic) NSString *notifyUrl;
@property (nonatomic) NSNumber *waresid;
@property (nonatomic) NSNumber *supportPayTypes;

+ (instancetype)defauLSJConfig;
@end

@interface LSJVIAPayConfig : NSObject

@property (nonatomic) NSNumber *supportPayTypes;

+ (instancetype)defauLSJConfig;

@end

@interface LSJMingPayConfig : NSObject

@property (nonatomic) NSString *payUrl;
@property (nonatomic) NSString *queryOrderUrl;
@property (nonatomic) NSString *mch;

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

@interface LSJWeiYingPayConfig : NSObject
@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *notifyUrl;
@end

@interface LSJDXTXPayConfig : NSObject
@property (nonatomic) NSString *appKey;
@property (nonatomic) NSString *notifyUrl;
@property (nonatomic) NSNumber *waresid;
@end

