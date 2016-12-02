//
//  LSJLecherModel.m
//  LSJVideo
//
//  Created by Liang on 16/8/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJLecherModel.h"

@implementation LSJLecherColumnsModel

- (Class)columnListElementClass {
    return [LSJColumnModel class];
}

@end


@implementation LSJLecherModelResponse

- (Class)columnListElementClass {
    return [LSJLecherColumnsModel class];
}

@end


@implementation LSJLecherModel

+ (Class)responseClass {
    return [LSJLecherModelResponse class];
}

- (BOOL)fetchLechersInfoWithCompletionHandler:(QBCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:LSJ_LECHERS_URL
                         standbyURLPath:[LSJUtil getStandByUrlPathWithOriginalUrl:LSJ_LECHERS_URL params:nil]
                             withParams:nil
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        LSJLecherModelResponse *resp = nil;
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
