//
//  LSJPaymentConfigModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJEncryptedURLRequest.h"
#import "LSJPaymentConfig.h"

@interface LSJPaymentConfigModel : LSJEncryptedURLRequest

@property (nonatomic,readonly) BOOL loaded;

+ (instancetype)sharedModel;

- (BOOL)fetchPaymentConfigInfoWithCompletionHandler:(LSJCompletionHandler)handler;

@end
