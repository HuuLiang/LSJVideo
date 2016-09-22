//
//  LSJPaymentViewController.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJBaseViewController.h"
#import "LSJBaseModel.h"

@interface LSJPaymentViewController : LSJBaseViewController

+ (instancetype)sharedPaymentVC;

- (void)popupPaymentInView:(UIView *)view
                 baseModel:(LSJBaseModel *)model
     withCompletionHandler:(void (^)(void))completionHandler;

- (void)hidePayment;

- (void)notifyPaymentResult:(QBPayResult)result withPaymentInfo:(QBPaymentInfo *)paymentInfo;
@end
