//
//  LSJActivateModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

typedef void (^LSJActivateHandler)(BOOL success, NSString *userId);

@interface LSJActivateModel : QBEncryptedURLRequest

+ (instancetype)sharedModel;

- (BOOL)activateWithCompletionHandler:(LSJActivateHandler)handler;

@end
