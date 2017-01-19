//
//  LSJPaymentViewController.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJPaymentViewController.h"
#import "LSJPaymentPopView.h"
#import "LSJSystemConfigModel.h"
#import <QBPaymentManager.h>

@interface LSJPaymentViewController ()
{
    UIImageView *_closeImgV;
}
@property (nonatomic) LSJPaymentPopView *popView;
@property (nonatomic,copy) dispatch_block_t completionHandler;
@property (nonatomic) LSJBaseModel *baseModel;
@end

@implementation LSJPaymentViewController
QBDefineLazyPropertyInitialization(LSJBaseModel, baseModel)

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
    
    
    if ([[QBPaymentManager sharedManager] isOrderPayTypeAvailable:QBOrderPayTypeWeChatPay]) {
        [availablePaymentTypes addObject:@{@"type" : @(QBOrderPayTypeWeChatPay)}];
    }
    if ([[QBPaymentManager sharedManager] isOrderPayTypeAvailable:QBOrderPayTypeAlipay]) {
        [availablePaymentTypes addObject:@{@"type" : @(QBOrderPayTypeAlipay)}];
    }
    if ([[QBPaymentManager sharedManager] isOrderPayTypeAvailable:QBOrderPayTypeQQPay]) {
        [availablePaymentTypes addObject:@{@"type" : @(QBOrderPayTypeQQPay)}];
    }
    
    _popView = [[LSJPaymentPopView alloc] initWithAvailablePaymentTypes:availablePaymentTypes];
    @weakify(self);
    _popView.paymentAction = ^(QBOrderPayType payType,LSJVipLevel vipLevel) {
        @strongify(self);
        
        [self payForPayType:payType withVipLevel:vipLevel];
        
        [self hidePayment];
    };
    _popView.closeAction = ^(id sender){
        @strongify(self);
        [self hidePayment];
        //        [[LSJStatsManager sharedManager] statsPayWithOrderNo:nil payAction:LSJStatsPayActionClose payResult:PAYRESULT_UNKNOWN forBaseModel:self.baseModel programLocation:NSNotFound andTabIndex:[LSJUtil currentTabPageIndex] subTabIndex:[LSJUtil currentSubTabPageIndex]];
//        
//        [[LSJStatsManager sharedManager] statsPayWithOrderNo:nil payAction:LSJStatsPayActionClose payResult:QBPayResultUnknown forBaseModel:self.baseModel andTabIndex:[LSJUtil currentTabPageIndex] subTabIndex:self.baseModel.subTab];
    };
    return _popView;
}

- (void)payForPayType:(QBOrderPayType)payType withVipLevel:(LSJVipLevel)vipLevel {
    @weakify(self);
    [[QBPaymentManager sharedManager] startPaymentWithOrderInfo:[self createOrderInfoWithPaymentType:payType vipLevel:vipLevel]     contentInfo:[self createContentInfo]
                            beginAction:^(QBPaymentInfo *paymentInfo) {
           if (paymentInfo) {
            
            [[LSJStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo forPayAction:LSJStatsPayActionGoToPay andTabIndex:[LSJUtil currentTabPageIndex] subTabIndex:self.baseModel.subTab];
        }
        
    } completionHandler:^(QBPayResult payResult, QBPaymentInfo *paymentInfo) {
        @strongify(self);
        [self notifyPaymentResult:payResult withPaymentInfo:paymentInfo];
    }];
    
}

- (QBOrderInfo *)createOrderInfoWithPaymentType:(QBOrderPayType)payType vipLevel:(LSJVipLevel)vipLevel {
    QBOrderInfo *orderInfo = [[QBOrderInfo alloc] init];
    
    NSString *channelNo = LSJ_CHANNEL_NO;
    if (channelNo.length > 14) {
        channelNo = [channelNo substringFromIndex:channelNo.length-14];
    }
    
    channelNo = [channelNo stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    
    NSString *uuid = [[NSUUID UUID].UUIDString.md5 substringWithRange:NSMakeRange(8, 16)];
    NSString *orderNo = [NSString stringWithFormat:@"%@_%@", channelNo, uuid];
    orderInfo.orderId = orderNo;
    
    NSUInteger price = 0;
    if (vipLevel == LSJVipLevelVip) {
        price = [LSJSystemConfigModel sharedModel].payAmount;
    } else if (vipLevel == LSJVipLevelSVip) {
        if (![LSJUtil isVip]) {
            price = [LSJSystemConfigModel sharedModel].svipPayAmount;
        } else {
            price = [LSJSystemConfigModel sharedModel].svipPayAmount - [LSJSystemConfigModel sharedModel].payAmount;
        }
    }
//    price = 200;
    
    orderInfo.orderPrice = price;
    
    NSString *orderDescription = @"VIP";
    
    orderInfo.orderDescription = orderDescription;
    orderInfo.payType = payType;
    orderInfo.reservedData = [LSJUtil paymentReservedData];
    orderInfo.createTime = [LSJUtil currentTimeString];
    orderInfo.payPointType = vipLevel;
    orderInfo.userId = [LSJUtil userId];
    
    return orderInfo;
}

- (QBContentInfo *)createContentInfo {
    QBContentInfo *contenInfo = [[QBContentInfo alloc] init];
    contenInfo.contentId = self.baseModel.programId;
    contenInfo.contentType = self.baseModel.programType;
    contenInfo.contentLocation = [NSNumber numberWithInteger:self.baseModel.programLocation];
    contenInfo.columnId = self.baseModel.realColumnId;
    contenInfo.columnType = self.baseModel.channelType;
    return contenInfo;
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
    
    if (_popView) {
        [_popView removeFromSuperview];
        _popView = nil;
    }
    
    if (self.view.superview) {
        [self.view removeFromSuperview];
    }
    self.view.frame = view.bounds;
    self.view.alpha = 0;
    
    UIView *hudView = [LSJHudManager manager].hudView;
    if (view == [UIApplication sharedApplication].keyWindow) {
        [view insertSubview:self.view belowSubview:hudView];
    } else {
        [view addSubview:self.view];
    }
    
    [self.view addSubview:self.popView];
    
    _closeImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_close"]];
    _closeImgV.userInteractionEnabled = YES;
    [self.view addSubview:_closeImgV];
    
    @weakify(self);
    [_closeImgV bk_whenTapped:^{
        @strongify(self);
        [self hidePayment];
        [[LSJStatsManager sharedManager] statsPayWithOrderNo:nil payAction:LSJStatsPayActionClose payResult:QBPayResultUnknown forBaseModel:self.baseModel andTabIndex:[LSJUtil currentTabPageIndex] subTabIndex:self.baseModel.subTab];
        [_closeImgV removeFromSuperview];
        _closeImgV = nil;
    }];
    
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:PaymentTypeSection];
//    [self.popView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//    
    {
        [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).offset(kWidth(50));
            make.size.mas_equalTo(CGSizeMake(kWidth(630),kWidth(920)));
        }];
        
        [_closeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.popView.mas_top);
            make.right.equalTo(self.popView.mas_right).offset(-kWidth(20));
            make.size.mas_equalTo(CGSizeMake(kWidth(72), kWidth(80)));
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
        
//        self.baseModel = nil;
        
    }];
}

- (void)notifyPaymentResult:(QBPayResult)result withPaymentInfo:(QBPaymentInfo *)paymentInfo {
    
    //    NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
    //    [dateFormmater setDateFormat:@"yyyyMMddHHmmss"];
    
    //    paymentInfo.paymentResult = @(result);
    //    paymentInfo.paymentStatus = @(LSJPaymentStatusNotProcessed);
    //    paymentInfo.paymentTime = [dateFormmater stringFromDate:[NSDate date]];
    //    [paymentInfo save];
    
    if (result == QBPayResultSuccess) {
        [LSJUtil registerVip];
        if (paymentInfo.payPointType == LSJVipLevelVip) {
            [LSJUtil registerVip];
        } else if (paymentInfo.payPointType == LSJVipLevelSVip) {
            [LSJUtil registerSVip];
        }
        
        [self hidePayment];
        [[LSJHudManager manager] showHudWithText:@"支付成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaidNotificationName object:paymentInfo];
        
        // [self.popView reloadData];
    } else if (result == QBPayResultFailure) {
        [[LSJHudManager manager] showHudWithText:@"支付取消"];
    } else {
        [[LSJHudManager manager] showHudWithText:@"支付失败"];
    }
    
    //    [[LSJPaymentModel sharedModel] commitPaymentInfo:paymentInfo];
    //    [[LSJStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo
    //                                               forPayAction:LSJStatsPayActionPayBack
    //                                                andTabIndex:[LSJUtil currentTabPageIndex]
    //                                                subTabIndex:[LSJUtil currentSubTabPageIndex]];
    [[LSJStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo forPayAction:LSJStatsPayActionPayBack andTabIndex:[LSJUtil currentTabPageIndex] subTabIndex:self.baseModel.subTab];
}
@end
