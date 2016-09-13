//
//  LSJPaymentConfig.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJURLResponse.h"
#import "LSJPaymentConfigSummary.h"
#import "LSJPaymentConfigDetail.h"

@interface LSJPaymentConfig : LSJURLResponse

@property (nonatomic,retain) LSJPaymentConfigSummary *payConfig;
@property (nonatomic,retain) LSJPaymentConfigDetail *configDetails;

+ (instancetype)sharedConfig;
- (void)setAsCurrentConfig;

- (LSJPaymentType)wechatPaymentType;
- (LSJPaymentType)alipayPaymentType;
- (LSJPaymentType)qqPaymentType;

@end
