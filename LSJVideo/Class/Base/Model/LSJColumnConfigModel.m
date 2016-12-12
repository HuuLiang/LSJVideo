//
//  LSJColumnConfigModel.m
//  LSJVideo
//
//  Created by Liang on 16/8/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJColumnConfigModel.h"

@implementation LSJColumnConfigResponse
- (Class)columnListElementClass {
    return [LSJColumnModel class];
}
@end


@implementation LSJColumnConfigModel
+(Class)responseClass {
    return [LSJColumnConfigResponse class];
}

- (BOOL)fetchColumnsInfoWithColumnId:(NSInteger)columnId IsProgram:(BOOL)isProgram CompletionHandler:(QBCompletionHandler)handler {
    @weakify(self);
    NSDictionary *params = nil;
    NSString *urlStr = nil;
    if (columnId != 0) {
        urlStr = LSJ_COLUMN_URL;
        params = @{@"columnId":@(columnId),
                   @"isProgram":@(isProgram)};
    } else {
        urlStr = LSJ_APPSPREAD_URL;
    }
    
    BOOL success = [self requestURLPath:urlStr
                         standbyURLPath:[LSJUtil getStandByUrlPathWithOriginalUrl:urlStr params:params]
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        LSJColumnConfigResponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                        }
                        
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess, resp.columnList);
                        }
                    }];
    
    return success;
}


@end

@implementation LSJColumnDayModel
RequestTimeOutInterval

+ (Class)responseClass {
    return [LSJColumnModel class];
}

- (BOOL)fetchDayInfoWithColumnId:(NSInteger)columnId CompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"columnId":@(columnId)};
    
    @weakify(self);
 
    BOOL success = [self requestURLPath:LSJ_COLUMN_DAY_URL
                         standbyURLPath:[LSJUtil getStandByUrlPathWithOriginalUrl:LSJ_COLUMN_DAY_URL params:params]
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        LSJColumnModel *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                        }
                        
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess, resp);
                        }
                    }];
    
    return success;
    
}

@end

