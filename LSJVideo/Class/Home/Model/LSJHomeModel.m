//
//  LSJHomeModel.m
//  LSJVideo
//
//  Created by Liang on 16/8/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJHomeModel.h"

@implementation LSJHomeColumnModel
- (Class)columnListElementClass {
    return [LSJColumnModel class];
}
@end


@implementation LSJHomeModelResponse
- (Class)columnListElementClass {
    return [LSJHomeColumnModel class];
}
@end


@implementation LSJHomeModel

+ (Class)responseClass {
    return [LSJHomeModelResponse class];
}

- (BOOL)fetchHomeInfoWithCompletionHandler:(LSJCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:LSJ_HOME_URL
                             withParams:nil
                        responseHandler:^(LSJURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        LSJHomeModelResponse *resp = nil;
                        if (respStatus == LSJURLResponseSuccess) {
                            resp = self.response;
                        }
                        
                        if (handler) {
                            handler(respStatus==LSJURLResponseSuccess, resp.columnList);
                        }
                    }];
    
    return success;
}


@end
