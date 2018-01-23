//
//  LSJManualActivationManager.m
//  LSJuaibo
//
//  Created by Sean Yue on 16/6/30.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJManualActivationManager.h"
#import "LSJPaymentViewController.h"

@interface LSJManualActivationManager ()
@end

@implementation LSJManualActivationManager

+ (instancetype)sharedManager {
    static LSJManualActivationManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)doActivation {
    if ([LSJUtil isVip] && [LSJUtil isSVip]) {
        [UIAlertView bk_showAlertViewWithTitle:@"您已经购买了全部VIP，无需再激活！" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
        return ;
    }
    
    NSArray<QBPaymentInfo *> *paymentInfos = [LSJUtil allUnsuccessfulPaymentInfos];
    if ([LSJUtil isVip] && ![LSJUtil isSVip]) {
        paymentInfos = [paymentInfos bk_select:^BOOL(QBPaymentInfo *paymentInfo) {
            return paymentInfo.payPointType == LSJVipLevelSVip;
        }];
    }
    
//    NSMutableString *orders = [NSMutableString string];
//    [paymentInfos enumerateObjectsUsingBlock:^(LSJPaymentInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.orderId.length > 0) {
//            [orders appendString:obj.orderId];
//            
//            if (idx != paymentInfos.count-1) {
//                [orders appendString:@"|"];
//            }
//        }
//    }];
//    
//    if (orders.length == 0) {
//        [UIAlertView bk_showAlertViewWithTitle:@"未找到支付成功的订单" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
//        return ;
//    }
    
    [[UIApplication sharedApplication].keyWindow beginLoading];
    [[QBPaymentManager sharedManager] activatePaymentInfos:paymentInfos withCompletionHandler:^(BOOL success, id obj) {
        [[UIApplication sharedApplication].keyWindow endLoading];
        
        if (success) {
            [UIAlertView bk_showAlertViewWithTitle:@"激活成功" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
            [[LSJPaymentViewController sharedPaymentVC] notifyPaymentResult:QBPayResultSuccess withPaymentInfo:obj];
        } else {
            [UIAlertView bk_showAlertViewWithTitle:@"未找到支付成功的订单" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
        }
    }];
}


- (void)servicesActivationWithOrderId:(NSString *)orderId {
    
}



@end
