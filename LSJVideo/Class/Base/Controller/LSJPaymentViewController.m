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
    
    
    QBPayType wechatPaymentType = [[QBPaymentManager sharedManager] wechatPaymentType];
    if (wechatPaymentType != QBPayTypeNone) {
        [availablePaymentTypes addObject:@{@"type" : @(wechatPaymentType),@"subType" : @(QBPaySubTypeWeChat)}];
    }
    
    QBPayType alipayPaymentType = [[QBPaymentManager sharedManager] alipayPaymentType];
    if (alipayPaymentType != QBPayTypeNone) {
        [availablePaymentTypes addObject:@{@"type" : @(alipayPaymentType),@"subType" : @(QBPaySubTypeAlipay)}];
    }
    
    QBPayType qqPaymentType = [[QBPaymentManager sharedManager] qqPaymentType];
    if (qqPaymentType != QBPayTypeNone) {
        [availablePaymentTypes addObject:@{@"type" : @(qqPaymentType),@"subType" : @(QBPaySubTypeQQ)}];
        
    }
    QBPayType cardPaymentType = [[QBPaymentManager sharedManager] cardPayPaymentType];
    if (cardPaymentType != QBPayTypeNone) {
        [availablePaymentTypes addObject:@{@"type" : @(cardPaymentType),@"subType" : @(QBPaySubTypeNone)}];
    }
    
    
    _popView = [[LSJPaymentPopView alloc] initWithAvailablePaymentTypes:availablePaymentTypes];
    @weakify(self);
    _popView.paymentAction = ^(QBPayType payType,QBPaySubType subType,LSJVipLevel vipLevel) {
        @strongify(self);
        
        [self payForPaymentType:payType subPaymentType:subType vipLevel:vipLevel];

        [self hidePayment];
    };
    _popView.closeAction = ^(id sender){
        @strongify(self);
        [self hidePayment];
//        [[LSJStatsManager sharedManager] statsPayWithOrderNo:nil payAction:LSJStatsPayActionClose payResult:PAYRESULT_UNKNOWN forBaseModel:self.baseModel programLocation:NSNotFound andTabIndex:[LSJUtil currentTabPageIndex] subTabIndex:[LSJUtil currentSubTabPageIndex]];
        
    };
    return _popView;
}

- (void)payForPaymentType:(QBPayType)paymentType subPaymentType:(QBPaySubType)subPaymentType vipLevel:(LSJVipLevel)vipLevel {

    
    QBPaymentInfo *paymentInfo = [self createPaymentInfoWithPaymentType:paymentType subPaymentType:subPaymentType vipLevel:vipLevel];
    
    [[QBPaymentManager sharedManager] startPaymentWithPaymentInfo:paymentInfo completionHandler:^(QBPayResult payResult, QBPaymentInfo *paymentInfo) {
        
        [self notifyPaymentResult:payResult withPaymentInfo:paymentInfo];
        
    }];
    
    if (paymentInfo) {
//        [[LSJStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo forPayAction:LSJStatsPayActionGoToPay andTabIndex:[LSJUtil currentTabPageIndex] subTabIndex:[LSJUtil currentSubTabPageIndex]];
    }
    
}

- (QBPaymentInfo *)createPaymentInfoWithPaymentType:(QBPayType)payType subPaymentType:(QBPaySubType)subPayType vipLevel:(LSJVipLevel)vipLevel {
    
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
    
    price = 200;
    
    NSString *channelNo = LSJ_CHANNEL_NO;
    channelNo = [channelNo substringFromIndex:channelNo.length-14];
    NSString *uuid = [[NSUUID UUID].UUIDString.md5 substringWithRange:NSMakeRange(8, 16)];
    NSString *orderNo = [NSString stringWithFormat:@"%@_%@", channelNo, uuid];
    
    QBPaymentInfo *paymentInfo = [[QBPaymentInfo alloc] init];
    paymentInfo.orderId = orderNo;
    paymentInfo.orderPrice = price;
    paymentInfo.contentId = self.baseModel.programId;
    paymentInfo.contentType = self.baseModel.programType;
    paymentInfo.contentLocation = @(self.baseModel.programLocation + 1);
    paymentInfo.columnId = self.baseModel.realColumnId;
    paymentInfo.columnType = self.baseModel.channelType;
    paymentInfo.payPointType = 1;
    paymentInfo.paymentTime = [LSJUtil currentTimeString];
    paymentInfo.paymentType = payType;
    paymentInfo.paymentSubType = subPayType;
    paymentInfo.paymentResult = QBPayResultUnknown;
    paymentInfo.paymentStatus = QBPayStatusPaying;
    paymentInfo.reservedData = [LSJUtil paymentReservedData];
    paymentInfo.orderDescription = @"VIP";
    paymentInfo.userId = [LSJUtil userId];
    
    return paymentInfo;
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
    
    UIView *hudView = [CRKHudManager manager].hudView;
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
        [_closeImgV removeFromSuperview];
        _closeImgV = nil;
    }];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:PaymentTypeSection];
    [self.popView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    {
        [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).offset(kWidth(50));
            make.size.mas_equalTo(CGSizeMake(kWidth(630),kWidth(920)));
        }];
        
        [_closeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.popView.mas_top);
            make.right.equalTo(self.popView.mas_right).offset(-kWidth(20));
            make.size.mas_equalTo(CGSizeMake(kWidth(36), kWidth(80)));
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

- (void)notifyPaymentResult:(QBPayResult)result withPaymentInfo:(QBPaymentInfo *)paymentInfo {
    
//    NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
//    [dateFormmater setDateFormat:@"yyyyMMddHHmmss"];
    
//    paymentInfo.paymentResult = @(result);
//    paymentInfo.paymentStatus = @(LSJPaymentStatusNotProcessed);
//    paymentInfo.paymentTime = [dateFormmater stringFromDate:[NSDate date]];
//    [paymentInfo save];
    
    if (result == QBPayResultSuccess) {
        [LSJUtil registerVip];
        [self hidePayment];
        [[CRKHudManager manager] showHudWithText:@"支付成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaidNotificationName object:paymentInfo];
        
        // [self.popView reloadData];
    } else if (result == QBPayResultFailure) {
        [[CRKHudManager manager] showHudWithText:@"支付取消"];
    } else {
        [[CRKHudManager manager] showHudWithText:@"支付失败"];
    }
    
//    [[LSJPaymentModel sharedModel] commitPaymentInfo:paymentInfo];
//    [[LSJStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo
//                                               forPayAction:LSJStatsPayActionPayBack
//                                                andTabIndex:[LSJUtil currentTabPageIndex]
//                                                subTabIndex:[LSJUtil currentSubTabPageIndex]];
}
@end
