//
//  LSJDetailModel.m
//  LSJVideo
//
//  Created by Liang on 16/8/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJDetailModel.h"

@implementation LSJDetailModel


- (BOOL)fetchProgramDetailInfoWithProgramId:(NSInteger)programId CompletionHandler:(LSJCompletionHandler)handler {
    NSDictionary *params = @{@"programId":@(programId)};
    
    BOOL success = [self requestURLPath:LSJ_DETAIL_URL
                             withParams:params
                        responseHandler:^(LSJURLResponseStatus respStatus, NSString *errorMessage)
    {
        if (respStatus == LSJURLResponseSuccess) {
            
        }
        
        if (handler) {
            handler(respStatus == LSJURLResponseSuccess,nil);
        }
        
    }];
    
    return success;
}

@end
