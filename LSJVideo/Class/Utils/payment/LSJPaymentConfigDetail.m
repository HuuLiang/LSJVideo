//
//  LSJPaymentConfigDetail.m
//  LSJVideo
//
//  Created by Liang on 16/9/13.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJPaymentConfigDetail.h"
#import "LSJPaymentConfigSummary.h"

NSString *const kLSJIAppPayConfigName = @"IAPPPAY";
NSString *const kLSJVIAPayConfigName = @"SYSK";
NSString *const kLSJMingPayConfigName = @"MPENG";
NSString *const kLSJSPayConfigName = @"WFT";
NSString *const kLSJHTPayConfigName = @"HAITUN";
NSString *const kLSJWeiYingConfigName = @"WEIYINGSDK";
NSString *const kLSJDXTXPayConfigName = @"DXTX";

@implementation LSJPaymentConfigDetail

- (Class)LSJ_classOfProperty:(NSString *)propName {
    if ([propName isEqualToString:NSStringFromSelector(@selector(iAppPayConfig))]) {
        return [LSJIAppPayConfig class];
    } else if ([propName isEqualToString:NSStringFromSelector(@selector(viaPayConfig))]) {
        return [LSJVIAPayConfig class];
    } else if ([propName isEqualToString:NSStringFromSelector(@selector(mingPayConfig))]) {
        return [LSJMingPayConfig class];
    } else if ([propName isEqualToString:NSStringFromSelector(@selector(spayConfig))]) {
        return [LSJSPayConfig class];
    } else if ([propName isEqualToString:NSStringFromSelector(@selector(haitunConfig))]) {
        return [LSJHTPayConfig class];
    } else if ([propName isEqualToString:NSStringFromSelector(@selector(weiYingPayConfig))]) {
        return [LSJWeiYingPayConfig class];
    } else if ([propName isEqualToString:NSStringFromSelector(@selector(dxtxPayConfig))]) {
        return [LSJDXTXPayConfig class];
    }
    return nil;
}

- (NSString *)LSJ_propertyOfParsing:(NSString *)parsingName {
    if ([parsingName hasSuffix:[@"-" stringByAppendingString:kLSJIAppPayConfigName]]) {
        return NSStringFromSelector(@selector(iAppPayConfig));
    } else if ([parsingName hasSuffix:[@"-" stringByAppendingString:kLSJVIAPayConfigName]]) {
        return NSStringFromSelector(@selector(viaPayConfig));
    } else if ([parsingName hasSuffix:[@"-" stringByAppendingString:kLSJMingPayConfigName]]) {
        return NSStringFromSelector(@selector(mingPayConfig));
    } else if ([parsingName hasSuffix:[@"-" stringByAppendingString:kLSJSPayConfigName]]) {
        return NSStringFromSelector(@selector(spayConfig));
    } else if ([parsingName hasSuffix:[@"-" stringByAppendingString:kLSJHTPayConfigName]]) {
        return NSStringFromSelector(@selector(haitunConfig));
    } else if ([parsingName hasSuffix:[@"-" stringByAppendingString:kLSJWeiYingConfigName]]) {
        return NSStringFromSelector(@selector(weiYingPayConfig));
    } else if ([parsingName hasSuffix:[@"-" stringByAppendingString:kLSJDXTXPayConfigName]]) {
        return NSStringFromSelector(@selector(dxtxPayConfig));
    }
    return nil;
}
@end

@implementation LSJIAppPayConfig

+ (instancetype)defauLSJConfig {
    LSJIAppPayConfig *config = [[self alloc] init];
    config.appid = @"3006339410";
    config.privateKey = @"MIICWwIBAAKBgQCHEQCLCZujWicF6ClEgHx4L/OdSHZ1LdKi/mzPOIa4IRfMOS09qDNV3+uK/zEEPu1DgO5Cl1lsm4xpwIiOqdXNRxLE9PUfgRy4syiiqRfofAO7w4VLSG4S0VU5F+jqQzKM7Zgp3blbc5BJ5PtKXf6zP3aCAYjz13HHH34angjg0wIDAQABAoGASOJm3aBoqSSL7EcUhc+j2yNdHaGtspvwj14mD0hcgl3xPpYYEK6ETTHRJCeDJtxiIkwfxjVv3witI5/u0LVbFmd4b+2jZQ848BHGFtZFOOPJFVCyLSJy5j5O79mEx0nJN0EJ/qadwezXr4UZLDIaJdWxhhvS+yDe0e0foz5AxWmkCQQDhd9U1uUasiMmH4WvHqMfq5l4y4U+V5SGb+IK+8Vi03Zfw1YDvKrgv1Xm1mdzYHFLkC47dhTm7/Ko8k5Kncf89AkEAmVtEtycnSYciSqDVXxWtH1tzsDeIMz/ZlDGXCAdUfRR2ZJ2u2jrLFunoS9dXhSGuERU7laasK0bDT4p0UwlhTwJAVF+wtPsRnI1PxX6xA7WAosH0rFuumax2SFTWMLhGduCZ9HEhX97/sD7V3gSnJWRsDJTasMEjWtrxpdufvPOnDQJAdsYPVGMItJPq5S3n0/rv2Kd11HdOD5NWKsa1mMxEjZN5lrfhoreCb7694W9pI31QWX6+ZUtvcR0fS82KBn3vVQJAa0fESiiDDrovKHBm/aYXjMV5anpbuAa5RJwCqnbjCWleZMwHV+8uUq9+YMnINZQnvi+C62It4BD+KrJn5q4pwg==";
    config.publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCbNQyxdpLeMwE0QMv/dB3Jn1SRqYE/u3QT3ig2uXu4yeaZo4f7qJomudLKKOgpa8+4a2JAPRBSueDpiytR0zN5hRZKImeZAu2foSYkpBqnjb5CRAH7roO7+ervoizg6bhAEx2zlLSJV9wZKQZ0Di5wCCV+bMSEXkYqfASRplYUvHwIDAQAB";
    config.waresid = @(1);
    config.notifyUrl = @"http://phas.ihuiyx.com/pd-has/notifyIpay.json";
    config.supportPayTypes = @(LSJSubPayTypeWeChat|LSJSubPayTypeAlipay);
    return config;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    LSJIAppPayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    [dicRep safelySetObject:self.appid forKey:@"appid"];
    [dicRep safelySetObject:self.privateKey forKey:@"privateKey"];
    [dicRep safelySetObject:self.notifyUrl forKey:@"notifyUrl"];
    [dicRep safelySetObject:self.waresid forKey:@"waresid"];
    [dicRep safelySetObject:self.supportPayTypes forKey:@"supportPayTypes"];
    [dicRep safelySetObject:self.publicKey forKey:@"publicKey"];
    return dicRep;
}
@end

@implementation LSJVIAPayConfig

+ (instancetype)defauLSJConfig {
    LSJVIAPayConfig *config = [[self alloc] init];
    //config.packageId = @"5361";
    config.supportPayTypes = @(LSJSubPayTypeAlipay|LSJSubPayTypeWeChat);
    return config;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    //    [dicRep safelySetObject:self.packageId forKey:@"packageId"];
    [dicRep safelySetObject:self.supportPayTypes forKey:@"supportPayTypes"];
    return dicRep;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    LSJVIAPayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}
@end

@implementation LSJSPayConfig

//+ (instancetype)defauLSJConfig {
//    LSJSPayConfig *config = [[self alloc] init];
//    config.mchId = @"5712000010";
//    config.notifyUrl = @"http://phas.ihuiyx.com/pd-has/notifyWft.json";
//    config.signKey = @"5afe11de0df374f5f78839db1904ff0d";
//    return config;
//}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    [dicRep safelySetObject:self.mchId forKey:@"mchId"];
    [dicRep safelySetObject:self.signKey forKey:@"signKey"];
    [dicRep safelySetObject:self.notifyUrl forKey:@"notifyUrl"];
    return dicRep;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    LSJSPayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}
@end

@implementation LSJHTPayConfig

+ (instancetype)defauLSJConfig {
    LSJHTPayConfig *config = [[self alloc] init];
    config.mchId = @"10605";
    config.key = @"e7c549c833cb9108e6524d075942119d";
    config.notifyUrl = @"http://phas.ihuiyx.com/pd-has/notifyHtPay.json";
    return config;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    [dicRep safelySetObject:self.mchId forKey:@"mchId"];
    [dicRep safelySetObject:self.key forKey:@"key"];
    [dicRep safelySetObject:self.notifyUrl forKey:@"notifyUrl"];
    return dicRep;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    LSJHTPayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}

@end

@implementation LSJMingPayConfig

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    [dicRep safelySetObject:self.mch forKey:@"mch"];
    return dicRep;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    LSJMingPayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}
@end

@implementation LSJWeiYingPayConfig

@end

@implementation LSJDXTXPayConfig

@end

