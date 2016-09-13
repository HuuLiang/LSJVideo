//
//  LSJPaymentConfig.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJPaymentConfig.h"

static LSJPaymentConfig *_shardConfig;
static NSString *const kPaymentConfigKeyName = @"LSJkuaibo_payment_config_key_name";

@interface LSJPaymentConfig ()
@property (nonatomic) NSNumber *code;
@property (nonatomic,retain) NSDictionary *paymentTypeMapping;
@end

@implementation LSJPaymentConfig

+ (instancetype)sharedConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *configDic = [[NSUserDefaults standardUserDefaults] objectForKey:kPaymentConfigKeyName];
        _shardConfig = [self objectFromDictionary:configDic withDecryptBlock:nil];
        
        if (!_shardConfig) {
            _shardConfig = [self defauLSJConfig];
        }
    });
    return _shardConfig;
}

+ (instancetype)defauLSJConfig {
    LSJPaymentConfig *defauLSJConfig = [[self alloc] init];
    
    defauLSJConfig.payConfig = [[LSJPaymentConfigSummary alloc] init];
    defauLSJConfig.payConfig.wechat = kLSJVIAPayConfigName;
    defauLSJConfig.payConfig.alipay = kLSJVIAPayConfigName;
    
    defauLSJConfig.configDetails = [[LSJPaymentConfigDetail alloc] init];
    defauLSJConfig.configDetails.viaPayConfig = [LSJVIAPayConfig defauLSJConfig];
    
    return defauLSJConfig;
}

- (NSDictionary *)paymentTypeMapping {
    if (_paymentTypeMapping) {
        return _paymentTypeMapping;
    }
    
    _paymentTypeMapping = @{kLSJVIAPayConfigName:@(LSJPaymentTypeVIAPay),
                            kLSJIAppPayConfigName:@(LSJPaymentTypeIAppPay),
                            kLSJSPayConfigName:@(LSJPaymentTypeSPay),
                            kLSJHTPayConfigName:@(LSJPaymentTypeHTPay),
                            kLSJMingPayConfigName:@(LSJPaymentTypeMingPay),
                            kLSJDXTXPayConfigName:@(LSJPaymentTypeDXTXPay)};
    return _paymentTypeMapping;
}

- (LSJPaymentType)wechatPaymentType {
    if (self.payConfig.wechat) {
        NSNumber *type = self.paymentTypeMapping[self.payConfig.wechat];
        return type ? type.unsignedIntegerValue : LSJPaymentTypeNone;
    }
    return LSJPaymentTypeNone;
}

- (LSJPaymentType)alipayPaymentType {
    if (self.payConfig.alipay) {
        NSNumber *type = self.paymentTypeMapping[self.payConfig.alipay];
        return type ? type.unsignedIntegerValue : LSJPaymentTypeNone;
    }
    return LSJPaymentTypeNone;
}

- (LSJPaymentType)qqPaymentType {
    if (self.payConfig.qqpay) {
        NSNumber *type = self.paymentTypeMapping[self.payConfig.qqpay];
        return type ? type.unsignedIntegerValue : LSJPaymentTypeNone;
    }
    return LSJPaymentTypeNone;
}

- (NSNumber *)success {
    return self.code.unsignedIntegerValue == 100 ? @(YES) : @(NO);
}

- (NSString *)resuLSJCode {
    return self.code.stringValue;
}

- (Class)payConfigClass {
    return [LSJPaymentConfigSummary class];
}

- (Class)configDetailsClass {
    return [LSJPaymentConfigDetail class];
}

- (void)setAsCurrentConfig {
    LSJPaymentConfig *currentConfig = [[self class] sharedConfig];
    currentConfig.payConfig = self.payConfig;
    currentConfig.configDetails = self.configDetails;
    
    [[NSUserDefaults standardUserDefaults] setObject:[self dictionaryRepresentationWithEncryptBlock:nil] forKey:kPaymentConfigKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
