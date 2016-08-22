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

- (BOOL)fetchProgramsInfoWithColumnId:(NSInteger)columnId IsProgram:(BOOL)isProgram CompletionHandler:(LSJCompletionHandler)handler {
    @weakify(self);
    NSDictionary *params = @{@"columnId":@(columnId),
                             @"isProgram":@(isProgram)};
    
    BOOL success = [self requestURLPath:LSJ_PROGRAM_URL
                             withParams:params
                        responseHandler:^(LSJURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        LSJColumnModel *resp = nil;
                        if (respStatus == LSJURLResponseSuccess) {
                            resp = self.response;
                        }
                        
                        if (handler) {
                            handler(respStatus == LSJURLResponseSuccess, resp);
                        }
                    }];
    
    return success;
}
@end
