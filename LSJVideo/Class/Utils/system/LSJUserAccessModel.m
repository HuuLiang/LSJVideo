//
//  LSJUserAccessModel.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJUserAccessModel.h"

@implementation LSJUserAccessModel

- (BOOL)shouldPostErrorNotification {
    return NO;
}

+ (Class)responseClass {
    return [NSString class];
}

+ (instancetype)sharedModel {
    static LSJUserAccessModel *_theInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _theInstance = [[LSJUserAccessModel alloc] init];
    });
    return _theInstance;
}

- (BOOL)requestUserAccess {
    NSString *userId = [LSJUtil userId];
    if (!userId) {
        return NO;
    }
    
    @weakify(self);
    BOOL ret = [super requestURLPath:LSJ_ACCESS_URL
                          withParams:@{@"userId":userId,@"accessId":[LSJUtil accessId]}
                     responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                {
                    @strongify(self);
                    
                    BOOL success = NO;
                    if (respStatus == QBURLResponseSuccess) {
                        NSString *resp = self.response;
                        success = [resp isEqualToString:@"SUCCESS"];
                        if (success) {
                            QBLog(@"Record user access!");
                        }
                    }
                }];
    return ret;
}


@end
