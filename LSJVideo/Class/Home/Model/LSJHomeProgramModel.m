//
//  LSJHomeProgramModel.m
//  LSJVideo
//
//  Created by Liang on 16/8/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJHomeProgramModel.h"

@implementation LSJHomeProgramListModel
- (Class)programListElementClass {
    return [LSJProgramModel class];
}
@end


@implementation LSJHomeProgramResponse
- (Class)columnListElementClass {
    return [LSJHomeProgramListModel class];
}
@end


@implementation LSJHomeProgramModel
+(Class)responseClass {
    return [LSJHomeProgramResponse class];
}

- (BOOL)fetchHomeInfoWithColumnId:(NSInteger)columnId IsProgram:(BOOL)isProgram CompletionHandler:(LSJCompletionHandler)handler {
    @weakify(self);
    NSDictionary *params = @{@"columnId":@(columnId),
                             @"isProgram":@(isProgram)};
    BOOL success = [self requestURLPath:LSJ_PROGRAM_URL
                             withParams:params
                        responseHandler:^(LSJURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        LSJHomeProgramResponse *resp = nil;
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
