//
//  LSJSystemConfigModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJEncryptedURLRequest.h"
#import "LSJSystemConfig.h"

@interface LSJSystemConfigResponse : LSJURLResponse

@property (nonatomic,retain) NSArray<LSJSystemConfig *> *confis;

@end

typedef void (^LSJFetchSystemConfigCompletionHandler)(BOOL success);

@interface LSJSystemConfigModel : LSJEncryptedURLRequest

@property (nonatomic) NSInteger payAmount;

+ (instancetype)sharedModel;

- (BOOL)fetchSystemConfigWithCompletionHandler:(LSJFetchSystemConfigCompletionHandler)handler;

@end
