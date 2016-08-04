//
//  LSJErrorHandler.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSJErrorHandler : NSObject

+ (instancetype)sharedHandler;
- (void)initialize;

@end

extern NSString *const kNetworkErrorNotification;
extern NSString *const kNetworkErrorCodeKey;
extern NSString *const kNetworkErrorMessageKey;
