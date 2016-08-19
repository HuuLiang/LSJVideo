//
//  LSJLecherModel.m
//  LSJVideo
//
//  Created by Liang on 16/8/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJLecherModel.h"

@implementation LSJLecherColumnResponse

- (Class)columnListElementClass {
    return [LSJColumnModel class];
}
@end


@implementation LSJLecherModel

+ (Class)responseClass {
    return [LSJLecherColumnResponse class];
}

- (BOOL)fetchLechersInfoWithCompletionHandler:(LSJCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:LSJ_LECHERS_URL
                             withParams:nil
                        responseHandler:^(LSJURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        LSJLecherColumnResponse *resp = nil;
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
