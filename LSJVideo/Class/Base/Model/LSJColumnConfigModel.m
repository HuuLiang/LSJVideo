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

- (BOOL)fetchColumnsInfoWithColumnId:(NSInteger)columnId IsProgram:(BOOL)isProgram CompletionHandler:(LSJCompletionHandler)handler {
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
                             withParams:params
                        responseHandler:^(LSJURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        LSJColumnConfigResponse *resp = nil;
                        if (respStatus == LSJURLResponseSuccess) {
                            resp = self.response;
                        }
                        
                        if (handler) {
                            handler(respStatus == LSJURLResponseSuccess, resp.columnList);
                        }
                    }];
    
    return success;
}
@end
