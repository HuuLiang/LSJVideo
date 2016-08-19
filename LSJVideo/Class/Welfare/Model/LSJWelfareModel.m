//
//  LSJWelfareModel.m
//  LSJVideo
//
//  Created by Liang on 16/8/17.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJWelfareModel.h"

@implementation LSJWelfareModel

+ (Class)responseClass {
    return [LSJColumnModel class];
}

- (BOOL)fetchWelfareInfoWithCompletionHandler:(LSJCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:LSJ_WELFARE_URL
                             withParams:@{@"isProgram":@(YES)}
                        responseHandler:^(LSJURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        LSJColumnModel *resp = nil;
                        if (respStatus == LSJURLResponseSuccess) {
                            resp = self.response;
                        }
                        
                        if (handler) {
                            handler(respStatus==LSJURLResponseSuccess, resp);
                        }
                    }];
    
    return success;
}

@end