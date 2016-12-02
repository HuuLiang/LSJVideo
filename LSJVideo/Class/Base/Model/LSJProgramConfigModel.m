//
//  LSJProgramConfigModel.m
//  LSJVideo
//
//  Created by Liang on 16/8/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJProgramConfigModel.h"

@implementation LSJProgramConfigModel
+(Class)responseClass {
    return [LSJColumnModel class];
}

- (BOOL)fetchProgramsInfoWithColumnId:(NSInteger)columnId IsProgram:(BOOL)isProgram CompletionHandler:(QBCompletionHandler)handler {
    @weakify(self);
    NSDictionary *params = @{@"columnId":@(columnId),
                             @"isProgram":@(isProgram)};

    BOOL success = [self requestURLPath:LSJ_COLUMN_URL
                         standbyURLPath:[LSJUtil getStandByUrlPathWithOriginalUrl:LSJ_COLUMN_URL params:params]
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
