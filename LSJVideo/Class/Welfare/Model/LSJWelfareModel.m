//
//  LSJWelfareModel.m
//  LSJVideo
//
//  Created by Liang on 16/8/17.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJWelfareModel.h"



@implementation LSJWelfareModel
- (BOOL)fetchWelfareInfoWithCompletionHandler:(LSJCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:LSJ_WELFARE_URL
                             withParams:nil
                        responseHandler:^(LSJURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
//                        LSJHomeModelResponse *resp = nil;
                        if (respStatus == LSJURLResponseSuccess) {
//                            resp = self.response;
                        }
                        
                        if (handler) {
//                            handler(respStatus==LSJURLResponseSuccess, resp.columnList);
                        }
                    }];
    
    return success;
}

@end
