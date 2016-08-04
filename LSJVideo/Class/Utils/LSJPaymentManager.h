//
//  LSJPaymentManager.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LSJBaseModel;

@interface LSJPaymentManager : NSObject

+ (instancetype)sharedManager;

- (void)setup;

- (LSJPaymentInfo *)startPaymentWithType:(LSJPaymentType)type
                                 subType:(LSJSubPayType)subType
                                   price:(NSUInteger)price
                               baseModel:(LSJBaseModel *)model
                       completionHandler:(LSJPaymentCompletionHandler)handler;


- (void)handleOpenUrl:(NSURL *)url;

- (LSJPaymentType)wechatPaymentType;
- (LSJPaymentType)alipayPaymentType;
- (LSJPaymentType)cardPayPaymentType;
- (LSJPaymentType)qqPaymentType;

@end
