//
//  LSJHomeModel.m
//  LSJVideo
//
//  Created by Liang on 16/8/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJHomeModel.h"

@implementation LSJHomeColumnsModel
- (Class)columnListElementClass {
    return [LSJColumnModel class];
}
@end


@implementation LSJHomeModelResponse
- (Class)columnListElementClass {
    return [LSJHomeColumnsModel class];
}
@end


@implementation LSJHomeModel

RequestTimeOutInterval

+ (Class)responseClass {
    return [LSJHomeModelResponse class];
}


- (BOOL)fetchHomeInfoWithCompletionHandler:(QBCompletionHandler)handler {
    @weakify(self);

    BOOL success = [self requestURLPath:LSJ_HOME_URL
                         standbyURLPath:[LSJUtil getStandByUrlPathWithOriginalUrl:LSJ_HOME_URL params:nil]
                             withParams:nil
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        LSJHomeModelResponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                        }
                        
                        if (handler) {
                            handler(respStatus==QBURLResponseSuccess, resp.columnList);
                        }
                    }];
    
    return success;
}


@end
