//
//  LSJSystemConfigModel.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJSystemConfigModel.h"

@implementation LSJSystemConfigResponse

- (Class)confisElementClass {
    return [LSJSystemConfig class];
}

@end

@implementation LSJSystemConfigModel

+ (instancetype)sharedModel {
    static LSJSystemConfigModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[LSJSystemConfigModel alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [LSJSystemConfigResponse class];
}

- (BOOL)fetchSystemConfigWithCompletionHandler:(LSJFetchSystemConfigCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:LSJ_SYSTEM_CONFIG_URL
                             withParams:@{@"type":@([LSJUtil deviceType])}
                        responseHandler:^(LSJURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        DLog("%ld %@",respStatus,errorMessage);
                        
                        if (respStatus == LSJURLResponseSuccess) {
                            LSJSystemConfigResponse *resp = self.response;
                            
                            [resp.confis enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                LSJSystemConfig *config = obj;
                                
                                if ([config.name isEqualToString:@"PAY_AMOUNT"]) {
                                    [LSJSystemConfigModel sharedModel].payAmount = [config.value integerValue];
                                }
                            }];
                        }
                        
                        if (handler) {
                            handler(respStatus == LSJURLResponseSuccess);
                        }
                        
                    }];
    return success;
    
}@end
