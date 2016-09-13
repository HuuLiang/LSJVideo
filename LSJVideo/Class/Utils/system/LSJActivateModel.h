//
//  LSJActivateModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJEncryptedURLRequest.h"

typedef void (^LSJActivateHandler)(BOOL success, NSString *userId);

@interface LSJActivateModel : LSJEncryptedURLRequest

+ (instancetype)sharedModel;

- (BOOL)activateWithCompletionHandler:(LSJActivateHandler)handler;

@end
