//
//  LSJPaymentViewController.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJPaymentViewController.h"
#import "LSJPaymentPopView.h"
#import "LSJPaymentManager.h"
#import "LSJPaymentConfig.h"
#import "LSJPaymentModel.h"
#import "LSJSystemConfigModel.h"

@interface LSJPaymentViewController ()
@property (nonatomic) LSJPaymentPopView *popView;
@property (nonatomic,copy) dispatch_block_t completionHandler;
@property (nonatomic) LSJBaseModel *baseModel;
@end

@implementation LSJPaymentViewController
DefineLazyPropertyInitialization(LSJBaseModel, baseModel)

+ (instancetype)sharedPaymentVC {
    static LSJPaymentViewController *_sharedPaymentVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPaymentVC = [[LSJPaymentViewController alloc] init];
    });
    return _sharedPaymentVC;
}

- (LSJPaymentPopView *)popView {
    if (_popView) {
        return _popView;
    }
    
    NSMutableArray *availablePaymentTypes = [NSMutableArray array];
    
    DLog("%@",[LSJPaymentConfig sharedConfig]);
    
    LSJPaymentType wechatPaymentType = [[LSJPaymentManager sharedManager] wechatPaymentType];
    if (wechatPaymentType != LSJPaymentTypeNone) {
        [availablePaymentTypes addObject:@{@"type" : @(LSJPaymentTypeVIAPay),@"subType" : @(LSJSubPayTypeWeChat)}];
    }
    
    LSJPaymentType alipayPaymentType = [[LSJPaymentManager sharedManager] alipayPaymentType];
    if (alipayPaymentType != LSJPaymentTypeNone) {
        [availablePaymentTypes addObject:@{@"type" : @(LSJPaymentTypeVIAPay),@"subType" : @(LSJSubPayTypeAlipay)}];
    }
    
    LSJPaymentType qqPaymentType = [[LSJPaymentManager sharedManager] qqPaymentType];
    if (qqPaymentType != LSJPaymentTypeNone) {
        [availablePaymentTypes addObject:@{@"type" : @(LSJPaymentTypeVIAPay),@"subType" : @(LSJSubPayTypeQQ)}];
        
    }
    LSJPaymentType cardPaymentType = [[LSJPaymentManager sharedManager] cardPayPaymentType];
    if (cardPaymentType != LSJPaymentTypeNone) {
        [availablePaymentTypes addObject:@{@"type" : @(LSJPaymentTypeIAppPay),@"subType" : @(LSJSubPayTypeNone)}];
    }
    
    
    _popView = [[LSJPaymentPopView alloc] initWithAvailablePaymentTypes:availablePaymentTypes];
    @weakify(self);
    _popView.paymentAction = ^(LSJPaymentType payType,LSJSubPayType subType) {
        @strongify(self);
        
        [self payForPaymentType:payType subPaymentType:subType];
        //        if (subPayType == LSJPaymentTypeWeChatPay) {
        //            [self payForPaymentType:wechatPaymentType subPaymentType:subPayType];
        //        } else if (subPayType == LSJPaymentTypeAlipay) {
        //            [self payForPaymentType:alipayPaymentType subPaymentType:subPayType];
        //        }else {
        //            [self payForPaymentType:cardPaymentType subPaymentType:LSJPaymentTypeNone];
        //        }
        
        [self hidePayment];
    };
    _popView.closeAction = ^(id sender){
        @strongify(self);
        [self hidePayment];
//        [[LSJStatsManager sharedManager] statsPayWithOrderNo:nil payAction:LSJStatsPayActionClose payResult:PAYRESULT_UNKNOWN forBaseModel:self.baseModel programLocation:NSNotFound andTabIndex:[LSJUtil currentTabPageIndex] subTabIndex:[LSJUtil currentSubTabPageIndex]];
        
    };
    return _popView;
}

- (void)payForPaymentType:(LSJPaymentType)paymentType subPaymentType:(LSJSubPayType)subPaymentType {
    LSJPaymentInfo *paymentInfo = [[LSJPaymentManager sharedManager] startPaymentWithType:paymentType
                                                                                subType:subPaymentType
                                                                                  price:[LSJSystemConfigModel sharedModel].payAmount
                                                                              baseModel:self.baseModel
                                                                      completionHandler:^(PAYRESULT payResult, LSJPaymentInfo *paymentInfo)
                                  {
                                      [self notifyPaymentResult:payResult withPaymentInfo:paymentInfo];
                                      
                                  }];
    
    DLog("%@",paymentInfo);
    if (paymentInfo) {
//        [[LSJStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo forPayAction:LSJStatsPayActionGoToPay andTabIndex:[LSJUtil currentTabPageIndex] subTabIndex:[LSJUtil currentSubTabPageIndex]];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)popupPaymentInView:(UIView *)view
                 baseModel:(LSJBaseModel *)model
     withCompletionHandler:(void (^)(void))completionHandler
{
    [self.view beginLoading];
    self.completionHandler = completionHandler;
    self.baseModel = model;
    
    if (self.view.superview) {
        [self.view removeFromSuperview];
    }
    self.view.frame = view.bounds;
    self.view.alpha = 0;
    
    UIView *hudView = [CRKHudManager manager].hudView;
    if (view == [UIApplication sharedApplication].keyWindow) {
        [view insertSubview:self.view belowSubview:hudView];
    } else {
        [view addSubview:self.view];
    }
    
    [self.view addSubview:self.popView];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:PaymentTypeSection];
    [self.popView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    {
        [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            
            const CGFloat width = kScreenWidth * 580/750.;
            CGFloat height = kScreenHeight * 630 /1334. + (kScreenHeight * 110 / 1334.) * (self.popView.availablePaymentTypes.count - 2.);
            make.size.mas_equalTo(CGSizeMake(width,height));
        }];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1.0;
    }];
}

- (void)hidePayment {
    [self.view endLoading];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        
        if (self.completionHandler) {
            self.completionHandler();
            self.completionHandler = nil;
        }
        
        self.baseModel = nil;
        
    }];
}

- (void)notifyPaymentResult:(PAYRESULT)result withPaymentInfo:(LSJPaymentInfo *)paymentInfo {
    
    NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
    [dateFormmater setDateFormat:@"yyyyMMddHHmmss"];
    
    paymentInfo.paymentResult = @(result);
    paymentInfo.paymentStatus = @(LSJPaymentStatusNotProcessed);
    paymentInfo.paymentTime = [dateFormmater stringFromDate:[NSDate date]];
    [paymentInfo save];
    
    if (result == PAYRESULT_SUCCESS) {
        [LSJUtil registerVip];
        [self hidePayment];
        [[CRKHudManager manager] showHudWithText:@"支付成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaidNotificationName object:paymentInfo];
        
        // [self.popView reloadData];
    } else if (result == PAYRESULT_ABANDON) {
        [[CRKHudManager manager] showHudWithText:@"支付取消"];
    } else {
        [[CRKHudManager manager] showHudWithText:@"支付失败"];
    }
    
    [[LSJPaymentModel sharedModel] commitPaymentInfo:paymentInfo];
//    [[LSJStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo
//                                               forPayAction:LSJStatsPayActionPayBack
//                                                andTabIndex:[LSJUtil currentTabPageIndex]
//                                                subTabIndex:[LSJUtil currentSubTabPageIndex]];
}
@end
