//
//  LSJPaymentModel.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJEncryptedURLRequest.h"
#import "LSJPaymentInfo.h"

@interface LSJPaymentModel : LSJEncryptedURLRequest
+ (instancetype)sharedModel;

- (void)startRetryingToCommitUnprocessedOrders;
- (void)commitUnprocessedOrders;
- (BOOL)commitPaymentInfo:(LSJPaymentInfo *)paymentInfo;

@end
