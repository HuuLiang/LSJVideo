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

+ (Class)responseClass {
    return [LSJHotModelResponse class];
}

- (BOOL)fetchHotInfoWithCompletionHadler:(LSJCompletionHandler)handler {
    @weakify(self)
    BOOL success = [self requestURLPath:LSJ_HOT_URL
                             withParams:nil
                        responseHandler:^(LSJURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        
        LSJHotModelResponse *resp = nil;
        if (respStatus == LSJURLResponseSuccess) {
            resp = self.response;
        }
        
        if (handler) {
            handler (respStatus == LSJURLResponseSuccess,resp.columnList);
        }
        
    }];
    return success;
}

@end
