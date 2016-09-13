//
//  DXTXPayManager.h
//  YYKuaibo
//
//  Created by Sean Yue on 16/9/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXTXPayManager : NSObject

@property (nonatomic) NSString *appKey;
@property (nonatomic) NSString *notifyUrl;
@property (nonatomic) NSNumber *waresid;
@property (nonatomic) NSString *schemeUrl;
+ (instancetype)sharedManager;

- (void)payWithPaymentInfo:(LSJPaymentInfo *)paymentInfo
         completionHandler:(LSJPaymentCompletionHandler)completionHandler;
- (void)handleOpenURL:(NSURL *)url;
@end
