//
//  LSJAppSpreadBannerModel.m
//  LSJVideo
//
//  Created by Liang on 16/9/28.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJAppSpreadBannerModel.h"

@implementation LSJAppSpreadBannerResponse

- (Class)programListElementClass {
    return [LSJProgramModel class];
}
@end

@implementation LSJAppSpreadBannerModel

+ (instancetype)sharedModel {
    static LSJAppSpreadBannerModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}
+ (Class)responseClass {
    return [LSJAppSpreadBannerResponse class];
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)fetchAppSpreadWithCompletionHandler:(QBCompletionHandler)handler {
    @weakify(self);
    BOOL ret = [self requestURLPath:LSJ_APP_SPREAD_BANNER_URL
                     standbyURLPath:nil
                         withParams:nil
                    responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                {
                    @strongify(self);
                    NSArray *fetchedSpreads;
                    if (respStatus == QBURLResponseSuccess) {
                        LSJAppSpreadBannerResponse *resp = self.response;
                        _fetchedSpreads = resp.programList;
                        fetchedSpreads = _fetchedSpreads;
                        self.realColumnId = resp.realColumnId;
                        self.type = resp.type;
                    }
                    
                    if (handler) {
                        handler(respStatus==QBURLResponseSuccess, fetchedSpreads);
                    }
                }];
    return ret;
}

@end
