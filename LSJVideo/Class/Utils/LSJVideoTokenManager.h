//
//  LSJVideoTokenManager.h
//  LSJVideo
//
//  Created by Liang on 16/9/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LSJVideoTokenCompletionHandler)(BOOL success, NSString *token, NSString *userId);

@interface LSJVideoTokenManager : NSObject

+ (instancetype)sharedManager;

- (void)requestTokenWithCompletionHandler:(LSJVideoTokenCompletionHandler)completionHandler;
- (NSString *)videoLinkWithOriginalLink:(NSString *)originalLink;

@end
