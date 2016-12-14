//
//  LSJVideoTokenManager.m
//  LSJVideo
//
//  Created by Liang on 16/9/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJVideoTokenManager.h"
#import <AFNetworking.h>
#import <NSDate+Utilities.h>
#import "LSJActivateModel.h"

static NSString *const kTokenURL = @"http://token.iqu8.cn/token";//@"http://bbs.qu8cc.com/token";
static NSString *const kTokenDataEncryptionPassword = @"fdl_2016$@Ask^we";

@interface LSJVideoTokenManager ()
@property (nonatomic) NSString *token;
@property (nonatomic,retain) NSDate *expireTime;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *httpHeaderValue;
@property (nonatomic) NSString *httpHeaderKey;
@end

@implementation LSJVideoTokenManager

+ (instancetype)sharedManager {
    static LSJVideoTokenManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)requestTokenWithCompletionHandler:(LSJVideoTokenCompletionHandler)completionHandler {
    
    if (self.token && self.expireTime && self.userId) {
        if ([self.expireTime isLaterThanDate:[NSDate date]]) {
            QBSafelyCallBlock(completionHandler, YES, self.token, self.userId);
            return ;
        }
    }
    
    if (![LSJUtil userId]) {
        @weakify(self);
        [[LSJActivateModel sharedModel] activateWithCompletionHandler:^(BOOL success, NSString *userId) {
            @strongify(self);
            if (success) {
                [self httpRequestTokenWithUserId:userId completionHandler:completionHandler];
            } else {
                QBSafelyCallBlock(completionHandler, NO, nil, nil);
            }
        }];
    } else {
        [self httpRequestTokenWithUserId:[LSJUtil userId] completionHandler:completionHandler];
    }
    
}

- (void)httpRequestTokenWithUserId:(NSString *)userId completionHandler:(LSJVideoTokenCompletionHandler)completionHandler {
    if (userId == nil) {
        QBSafelyCallBlock(completionHandler, NO, nil, nil);
        return ;
    }
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
    if (self.httpHeaderValue && self.httpHeaderKey) {
        [sessionManager.requestSerializer setValue:self.httpHeaderValue forHTTPHeaderField:self.httpHeaderKey];
    }
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *dataString = [NSString stringWithFormat:@"uid=%@&channelNo=%@&appId=%@", userId, LSJ_CHANNEL_NO, LSJ_REST_APPID];
    NSDictionary *params = @{@"data":[dataString encryptedStringWithPassword:kTokenDataEncryptionPassword]};
    
    @weakify(self);
    [sessionManager POST:kTokenURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *encryptedData = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *dataString = [encryptedData decryptedStringWithPassword:kTokenDataEncryptionPassword];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        QBLog(@"Token request response: %@", dic);
        
        NSString *token = dic[@"token"];
        NSNumber *expireTime = dic[@"expireTime"];
        
        if (!token || !expireTime) {
            QBSafelyCallBlock(completionHandler, NO, nil, nil);
            return ;
        }
        
        @strongify(self);
        self.userId = userId;
        self.token = token;
        self.expireTime = [NSDate dateWithTimeIntervalSinceNow:expireTime.integerValue/2];
        QBSafelyCallBlock(completionHandler, YES, token, userId);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QBLog(@"Token request error: %@", error.localizedDescription);
        QBSafelyCallBlock(completionHandler, NO, nil, nil);
    }];
}

- (NSString *)videoLinkWithOriginalLink:(NSString *)originalLink {
    if (!self.token || !self.userId) {
        return originalLink;
    }
    
    NSString *videoLink = [NSString stringWithFormat:@"%@?uid=%@&token=%@&verCode=%@", originalLink, self.userId, self.token, @"20160923"];
    return videoLink;
}

- (void)setValue:(NSString *)value forVideoHttpHeader:(NSString *)field {
    self.httpHeaderKey = field;
    self.httpHeaderValue = value;
}
@end

