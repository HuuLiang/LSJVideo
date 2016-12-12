//
//  LSJDetailModel.m
//  LSJVideo
//
//  Created by Liang on 16/8/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJDetailModel.h"

@implementation LSJProgramUrlModel

@end


@implementation LSJDetailResponse

- (Class)commentJsonElementClass {
    return [LSJCommentModel class];
}

- (Class)programUrlListElementClass {
    return [LSJProgramUrlModel class];
}

- (Class)programClass {
    return [LSJProgramModel class];
}
@end


@implementation LSJDetailModel

RequestTimeOutInterval

+ (Class)responseClass {
    return [LSJDetailResponse class];
}

- (BOOL)fetchProgramDetailInfoWithColumnId:(NSInteger)columnId ProgramId:(NSInteger)programId isImageText:(BOOL)isImageText CompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"columnId":@(columnId),
                             @"programId":@(programId)};
    
    BOOL success = [self requestURLPath:isImageText ? LSJ_WELFAREDETAIL_URL : LSJ_DETAIL_URL
                         standbyURLPath:[LSJUtil getStandByUrlPathWithOriginalUrl:isImageText ? LSJ_WELFAREDETAIL_URL : LSJ_DETAIL_URL params:params]
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        LSJDetailModel *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,resp);
        }
        
    }];
    
    return success;
}

@end
