//
//  LSJUserAccessModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJEncryptedURLRequest.h"

typedef void (^LSJUserAccessCompletionHandler)(BOOL success);

@interface LSJUserAccessModel : LSJEncryptedURLRequest

+ (instancetype)sharedModel;

- (BOOL)requestUserAccess;

@end
