//
//  LSJPaymentManager.m
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJPaymentManager.h"
#import "LSJPaymentConfigModel.h"
#import "LSJBaseModel.h"
#import "LSJSystemConfigModel.h"

#import "IappPayMananger.h"
#import <PayUtil/PayUtil.h>
#import "DXTXPayManager.h"

typedef NS_ENUM(NSUInteger, LSJVIAPayType) {
    LSJVIAPayTypeNone,
    LSJVIAPayTypeWeChat = 2,
    LSJVIAPayTypeQQ = 3,
    LSJVIAPayTypeUPPay = 4,
    LSJVIAPayTypeShenZhou = 5
};

static NSString *const KAliPaySchemeUrl = @"comLSJyingyuanappAliPayUrlScheme";
static NSString *const kIappPaySchemeUrl = @"comLSJyingyuanappIappPayUrlScheme";
static NSString *const kpaymentConfigKeyName = @"lulushequ_paymentConfig_keyname";
static NSString *const kDxtxSchemeUrl = @"comLSJyingyuanDXTXPayDemoScheme";


@interface LSJPaymentManager () <stringDelegate>
@property (nonatomic,retain) LSJPaymentInfo *paymentInfo;

@property (nonatomic,copy) LSJPaymentCompletionHandler completionHandler;
@end

@implementation LSJPaymentManager

+ (instancetype)sharedManager {
    static LSJPaymentManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)setup {
    [[PayUitls getIntents] initSdk];
    [paySender getIntents].delegate = self;
    
    [[LSJPaymentConfigModel sharedModel] fetchPaymentConfigInfoWithCompletionHandler:^(BOOL success, id obj) {
        if (success) {
            LSJPaymentConfig *config = obj;
            [[IappPayMananger sharedMananger] setPayWithAppId:config.configDetails.iAppPayConfig.appid mACID:nil];
            [DXTXPayManager sharedManager].appKey = [LSJPaymentConfig sharedConfig].configDetails.dxtxPayConfig.appKey;
            [DXTXPayManager sharedManager].notifyUrl = [LSJPaymentConfig sharedConfig].configDetails.dxtxPayConfig.notifyUrl;
            [DXTXPayManager sharedManager].waresid = [LSJPaymentConfig sharedConfig].configDetails.dxtxPayConfig.waresid;
            [DXTXPayManager sharedManager].schemeUrl = kDxtxSchemeUrl;
        }
    }];
    [IappPayMananger sharedMananger].alipayURLScheme = kIappPaySchemeUrl;
    
    Class class = NSClassFromString(@"VIASZFViewController");
    if (class) {
        [class aspect_hookSelector:NSSelectorFromString(@"viewWillAppear:")
                       withOptions:AspectPositionAfter
                        usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated)
         {
             UIViewController *thisVC = [aspectInfo instance];
             if ([thisVC respondsToSelector:NSSelectorFromString(@"buy")]) {
                 UIViewController *buyVC = [thisVC valueForKey:@"buy"];
                 [buyVC.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     if ([obj isKindOfClass:[UIButton class]]) {
                         UIButton *buyButton = (UIButton *)obj;
                         if ([[buyButton titleForState:UIControlStateNormal] isEqualToString:@"购卡支付"]) {
                             [buyButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                         }
                     }
                 }];
             }
         } error:nil];
    }
}

- (LSJPaymentType)wechatPaymentType {
    return [LSJPaymentConfig sharedConfig].wechatPaymentType;
}

- (LSJPaymentType)alipayPaymentType {
    return [LSJPaymentConfig sharedConfig].alipayPaymentType;
}

- (LSJPaymentType)cardPayPaymentType {
    
    return LSJPaymentTypeNone;
}

- (LSJPaymentType)qqPaymentType {
    return [LSJPaymentConfig sharedConfig].qqPaymentType;
}

- (void)handleOpenUrl:(NSURL *)url {
    if ([url.absoluteString rangeOfString:kIappPaySchemeUrl].location == 0) {
        [[IappPayMananger sharedMananger] handleOpenURL:url];
    } else if ([url.absoluteString rangeOfString:KAliPaySchemeUrl].location == 0) {
        [[PayUitls getIntents] paytoAli:url];
    } else if ([url.absoluteString rangeOfString:kDxtxSchemeUrl].location == 0) {
        [[DXTXPayManager sharedManager] handleOpenURL:url];
    }
}

- (LSJPaymentInfo *)startPaymentWithType:(LSJPaymentType)type
                                subType:(LSJSubPayType)subType
                                  price:(NSUInteger)price
                              baseModel:(LSJBaseModel *)model
                      completionHandler:(LSJPaymentCompletionHandler)handler {
    NSString *channelNo = LSJ_CHANNEL_NO;
    channelNo = [channelNo substringFromIndex:channelNo.length-14];
    NSString *uuid = [[NSUUID UUID].UUIDString.md5 substringWithRange:NSMakeRange(8, 16)];
    NSString *orderNo = [NSString stringWithFormat:@"%@_%@", channelNo, uuid];
#if DEBUG
    price = 1;
#endif
    LSJPaymentInfo *paymentInfo = [[LSJPaymentInfo alloc] init];
    paymentInfo.orderId = orderNo;
    paymentInfo.orderPrice = @(price);
    paymentInfo.contentId = model.programId;
    paymentInfo.contentType = model.programType;
    paymentInfo.contentLocation = @(model.programLocation + 1);
    paymentInfo.columnId = model.realColumnId;
    paymentInfo.columnType = model.channelType;
    paymentInfo.payPointType = @(1);
    paymentInfo.paymentTime = [LSJUtil currentTimeString];
    paymentInfo.paymentType = @(type);
    paymentInfo.paymentResult = @(PAYRESULT_UNKNOWN);
    paymentInfo.paymentStatus = @(LSJPaymentStatusPaying);
    paymentInfo.reservedData = [LSJUtil paymentReservedData];
    [paymentInfo save];
    
    self.completionHandler = handler;
    self.paymentInfo = paymentInfo;
    
    BOOL success = YES;
    
    if (type == LSJPaymentTypeVIAPay && (subType == LSJSubPayTypeWeChat || subType == LSJSubPayTypeAlipay || subType == LSJSubPayTypeQQ)) {
        
        NSDictionary *viaPayTypeMapping = @{@(LSJSubPayTypeAlipay):@(LSJVIAPayTypeShenZhou),
                                            @(LSJSubPayTypeWeChat):@(LSJVIAPayTypeWeChat),
                                            @(LSJSubPayTypeQQ):@(LSJVIAPayTypeQQ)};
        NSString *tradeName = @"VIP会员";
        [[PayUitls getIntents]   gotoPayByFee:@(price).stringValue
                                 andTradeName:tradeName
                              andGoodsDetails:tradeName
                                    andScheme:KAliPaySchemeUrl
                            andchannelOrderId:[orderNo stringByAppendingFormat:@"$%@", LSJ_REST_APPID]
                                      andType:[viaPayTypeMapping[@(subType)] stringValue]
                             andViewControler:[LSJUtil currentVisibleViewController]];
    }else if (type == LSJPaymentTypeIAppPay){
        
        @weakify(self);
        IappPayMananger *iAppMgr = [IappPayMananger sharedMananger];
        iAppMgr.appId = [LSJPaymentConfig sharedConfig].configDetails.iAppPayConfig.appid;
        iAppMgr.privateKey = [LSJPaymentConfig sharedConfig].configDetails.iAppPayConfig.privateKey;
        iAppMgr.waresid = [LSJPaymentConfig sharedConfig].configDetails.iAppPayConfig.waresid.stringValue;
        iAppMgr.appUserId = [LSJUtil userId].md5 ?: @"UnregisterUser";
        iAppMgr.privateInfo = LSJ_PAYMENT_RESERVE_DATA;
        iAppMgr.notifyUrl = [LSJPaymentConfig sharedConfig].configDetails.iAppPayConfig.notifyUrl;
        iAppMgr.publicKey = [LSJPaymentConfig sharedConfig].configDetails.iAppPayConfig.publicKey;
        
        [iAppMgr payWithPaymentInfo:paymentInfo payType:subType completionHandler:^(PAYRESULT payResult, LSJPaymentInfo *paymentInfo) {
            @strongify(self);
            
            if (self.completionHandler) {
                self.completionHandler(payResult, self.paymentInfo);
            }
        }];
        
    } else {
        success = NO;
        
        if (self.completionHandler) {
            self.completionHandler(PAYRESULT_FAIL, paymentInfo);
        }
    }
    
    return success ? paymentInfo : nil;
}

#pragma mark - stringDelegate

- (void)getResult:(NSDictionary *)sender {
    PAYRESULT paymentResult = [sender[@"result"] integerValue] == 0 ? PAYRESULT_SUCCESS : PAYRESULT_FAIL;
    
    //    [self onPaymentResult:paymentResult withPaymentInfo:self.paymentInfo];
    
    if (self.completionHandler) {
        if ([NSThread currentThread].isMainThread) {
            self.completionHandler(paymentResult, self.paymentInfo);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completionHandler(paymentResult, self.paymentInfo);
            });
        }
    }
}
@end
