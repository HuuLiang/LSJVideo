//
//  LSJVersionUpdateModel.m
//  LSJuaibo
//
//  Created by ylz on 2016/12/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJVersionUpdateModel.h"

@implementation LSJVersionUpdateInfo

@end

@implementation LSJVersionUpdateModel

+ (instancetype)sharedModel {
    static LSJVersionUpdateModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

+ (Class)responseClass {
    return [LSJVersionUpdateInfo class];
}

//- (NSURL *)baseURL {
//    return nil;
//}

- (BOOL)fetchLatestVersionWithCompletionHandler:(QBCompletionHandler)completionHandler {
    @weakify(self);
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
    BOOL rect = [self requestURLPath:LSJ_VERSION_UPDATE_URL withParams:@{@"versionNo":currentVersion, @"packageId":bundleId} responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        LSJVersionUpdateInfo *versionInfo;
        if (respStatus == QBURLResponseSuccess) {
            versionInfo = self.response;
            self->_fetchedVersionInfo = versionInfo;
        }
        
        QBSafelyCallBlock(completionHandler, respStatus==QBURLResponseSuccess, versionInfo);
    }];
    return rect;
}

@end
