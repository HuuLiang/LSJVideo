//
//  LSJHotModel.m
//  LSJVideo
//
//  Created by Liang on 16/8/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJHotModel.h"

@implementation LSJHotModelResponse

- (Class)columnListElementClass {
    return [LSJColumnModel class];
}

@end

@implementation LSJHotModel

RequestTimeOutInterval

+ (Class)responseClass {
    return [LSJHotModelResponse class];
}

- (BOOL)fetchHotInfoWithCompletionHadler:(QBCompletionHandler)handler {
    @weakify(self)
    BOOL success = [self requestURLPath:LSJ_HOT_URL
                         standbyURLPath:[LSJUtil getStandByUrlPathWithOriginalUrl:LSJ_HOT_URL params:nil]
                             withParams:nil
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        
        LSJHotModelResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        
        if (handler) {
            handler (respStatus == QBURLResponseSuccess,resp.columnList);
        }
        
    }];
    return success;
}

@end
