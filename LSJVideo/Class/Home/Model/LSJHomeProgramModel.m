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
    NSDictionary *params = nil;
    NSString *urlStr = nil;
    if (columnId != 0) {
        urlStr = LSJ_PROGRAM_URL;
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
                        LSJHomeProgramResponse *resp = nil;
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
