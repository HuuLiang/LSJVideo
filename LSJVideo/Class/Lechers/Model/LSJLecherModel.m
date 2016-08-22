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

- (BOOL)fetchLechersInfoWithCompletionHandler:(LSJCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:LSJ_LECHERS_URL
                             withParams:nil
                        responseHandler:^(LSJURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        LSJLecherModelResponse *resp = nil;
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
