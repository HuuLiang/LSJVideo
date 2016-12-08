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
                         standbyURLPath:[LSJUtil getStandByUrlPathWithOriginalUrl:LSJ_SYSTEM_CONFIG_URL params:@{@"type":@([LSJUtil deviceType])}]
                             withParams:@{@"type":@([LSJUtil deviceType])}
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        QBLog(@"%ld %@",respStatus,errorMessage);
                        
                        if (respStatus == QBURLResponseSuccess) {
                            LSJSystemConfigResponse *resp = self.response;
                            
                            [resp.confis enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                LSJSystemConfig *config = obj;
                                
                                if ([config.name isEqualToString:LSJ_SYSTEM_PAY_AMOUNT]) {
                                    [LSJSystemConfigModel sharedModel].payAmount = [config.value integerValue];
                                } else if ([config.name isEqualToString:LSJ_SYSTEM_SVIP_PAY_AMOUNT]) {
                                    [LSJSystemConfigModel sharedModel].svipPayAmount = [config.value integerValue];
                                } else if ([config.name isEqualToString:LSJ_SYSTEM_CONTACT_NAME]) {
                                    [LSJSystemConfigModel sharedModel].contacName = config.value;
                                } else if ([config.name isEqualToString:LSJ_SYSTEM_CONTACT_SCHEME]) {
                                    [LSJSystemConfigModel sharedModel].contactScheme = config.value;
                                } else if ([config.name isEqualToString:LSJ_SYSTEM_MINE_IMG]) {
                                    [LSJSystemConfigModel sharedModel].mineImgUrl = config.value;
                                } else if ([config.name isEqualToString:LSJ_SYSTEM_PAY_IMG]) {
                                    [LSJSystemConfigModel sharedModel].vipImg = config.value;
                                } else if ([config.name isEqualToString:LSJ_SYSTEM_SVIP_PAY_IMG]) {
                                    [LSJSystemConfigModel sharedModel].sVipImg = config.value;
                                } else if ([config.name isEqualToString:LSJ_SYSTEM_IMAGE_TOKEN]) {
                                    [LSJSystemConfigModel sharedModel].imageToken = config.value;
                                }
                            }];
                            _loaded = YES;
                        }else {
                            [LSJSystemConfigModel sharedModel].payAmount = 4900;
                            [LSJSystemConfigModel sharedModel].svipPayAmount = 6900;
                        }
                        
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess);
                        }
                    }];
    return success;
}
@end
