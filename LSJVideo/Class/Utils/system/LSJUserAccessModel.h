//
//  LSJUserAccessModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

typedef void (^LSJUserAccessCompletionHandler)(BOOL success);

@interface LSJUserAccessModel : QBEncryptedURLRequest

+ (instancetype)sharedModel;

- (BOOL)requestUserAccess;

@end
