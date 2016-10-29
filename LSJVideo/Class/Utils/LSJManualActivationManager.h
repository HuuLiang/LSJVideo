//
//  LSJManualActivationManager.h
//  LSJuaibo
//
//  Created by Sean Yue on 16/6/30.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSJManualActivationManager : NSObject

+ (instancetype)sharedManager;

- (void)doActivation;

- (void)servicesActivationWithOrderId:(NSString *)orderId;

@end
