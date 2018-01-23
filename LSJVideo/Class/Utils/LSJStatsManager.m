//
//  LSJStatsManager.m
//  LSJuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJStatsManager.h"
#import "LSJCPCStatsModel.h"
#import "LSJTabStatsModel.h"
#import "LSJPayStatsModel.h"
#import "MobClick.h"
#import "LSJCPCStatsModel.h"

static NSString *const kUmengCPCChannelEvent = @"CPC_CHANNEL";
static NSString *const kUmengCPCProgramEvent = @"CPC_PROGRAM";
static NSString *const kUmengTabEvent = @"TAB_STATS";
static NSString *const kUmengPayEvent = @"PAY_STATS";

@interface LSJStatsManager ()
@property (nonatomic,retain) dispatch_queue_t queue;
@property (nonatomic,retain,readonly) LSJCPCStatsModel *cpcStats;
@property (nonatomic,retain,readonly) LSJTabStatsModel *tabStats;
@property (nonatomic,retain,readonly) LSJPayStatsModel *payStats;
@property (nonatomic,retain,readonly) NSDate *statsDate;
@property (nonatomic)BOOL scheduling;
@end

@implementation LSJStatsManager
@synthesize cpcStats = _cpcStats;
@synthesize tabStats = _tabStats;
@synthesize payStats = _payStats;

QBDefineLazyPropertyInitialization(LSJCPCStatsModel, cpcStats)
QBDefineLazyPropertyInitialization(LSJTabStatsModel, tabStats)
QBDefineLazyPropertyInitialization(LSJPayStatsModel, payStats)

- (dispatch_queue_t)queue {
    if (_queue) {
        return _queue;
    }
    
    _queue = dispatch_queue_create("com.LSJuaibo.app.statsq", nil);
    return _queue;
}

+ (instancetype)sharedManager {
    static LSJStatsManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _statsDate = [NSDate date];
    }
    return self;
}

- (void)addStats:(LSJStatsInfo *)statsInfo {
    dispatch_async(self.queue, ^{
        [statsInfo save];
    });
}

- (void)removeStats:(NSArray<LSJStatsInfo *> *)statsInfos {
    dispatch_async(self.queue, ^{
        [LSJStatsInfo removeStatsInfos:statsInfos];
    });
}

- (void)scheduleStatsUploadWithTimeInterval:(NSTimeInterval)timeInterval {
    
    if (self.scheduling) {
        return;
    }
    self.scheduling = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        while (1) {
            dispatch_async(self.queue, ^{
                [self uploadStatsInfos:[LSJStatsInfo allStatsInfos]];
            });
            sleep(timeInterval);
        }
    });
}

- (void)uploadStatsInfos:(NSArray<LSJStatsInfo *> *)statsInfos {
    if (statsInfos.count == 0) {
        return ;
    }
    
    NSArray<LSJStatsInfo *> *cpcStats = [statsInfos bk_select:^BOOL(LSJStatsInfo *statsInfo) {
        return statsInfo.statsType.unsignedIntegerValue == LSJStatsTypeColumnCPC
        || statsInfo.statsType.unsignedIntegerValue == LSJStatsTypeProgramCPC;
    }];
    
    NSArray<LSJStatsInfo *> *tabStats = [statsInfos bk_select:^BOOL(LSJStatsInfo *statsInfo) {
        return statsInfo.statsType.unsignedIntegerValue == LSJStatsTypeTabCPC
        || statsInfo.statsType.unsignedIntegerValue == LSJStatsTypeTabPanning
        || statsInfo.statsType.unsignedIntegerValue == LSJStatsTypeTabStay
        || statsInfo.statsType.unsignedIntegerValue == LSJStatsTypeBannerPanning;
    }];
    
    NSArray<LSJStatsInfo *> *payStats = [statsInfos bk_select:^BOOL(LSJStatsInfo *statsInfo) {
        return statsInfo.statsType.unsignedIntegerValue == LSJStatsTypePay;
    }];
    
    if (cpcStats.count > 0) {
        QBLog(@"Commit CPC stats...");
        [self.cpcStats statsCPCWithStatsInfos:cpcStats completionHandler:^(BOOL success, id obj) {
            if (success) {
                [LSJStatsInfo removeStatsInfos:cpcStats];
                QBLog(@"Commit CPC stats successfully!");
            } else {
                QBLog(@"Commit CPC stats with failure: %@", obj);
            }
        }];
    }
    
    if (tabStats.count > 0) {
        QBLog(@"Commit TAB stats...");
        [self.tabStats statsTabWithStatsInfos:tabStats completionHandler:^(BOOL success, id obj) {
            if (success) {
                [LSJStatsInfo removeStatsInfos:tabStats];
                QBLog(@"Commit TAB stats successfully");
            } else {
                QBLog(@"Commint TAB stats with failure: %@", obj);
            }
        }];
    }
    
    if (payStats.count > 0) {
        QBLog(@"Commit PAY stats...");
        [self.payStats statsPayWithStatsInfos:payStats completionHandler:^(BOOL success, id obj) {
            if (success) {
                [LSJStatsInfo removeStatsInfos:payStats];
                QBLog(@"Commit PAY stats successfully!");
            } else {
                QBLog(@"Commit PAY stats with failure: %@", obj);
            }
        }];
    }
} 

- (void)statsCPCWithBaseModel:(LSJBaseModel *)baseModel inTabIndex:(NSUInteger)tabIndex {
    LSJStatsInfo *statsInfo = [[LSJStatsInfo alloc] init];
    statsInfo.tabpageId = @(tabIndex+1);
    if (baseModel.subTab != NSNotFound) {
        statsInfo.subTabpageId = @(baseModel.subTab +1);
    }
    statsInfo.columnId = baseModel.realColumnId;
    statsInfo.columnType = baseModel.channelType;
    statsInfo.statsType = @(LSJStatsTypeColumnCPC);
    [self addStats:statsInfo];
    
    [MobClick event:kUmengCPCChannelEvent attributes:[statsInfo umengAttributes]];
}

- (void)statsCPCWithBaseModel:(LSJBaseModel *)baseModel
                  andTabIndex:(NSUInteger)tabIndex
                  subTabIndex:(NSUInteger)subTabIndex
{
    LSJStatsInfo *statsInfo = [[LSJStatsInfo alloc] init];
    if (baseModel) {
        statsInfo.columnId = baseModel.realColumnId;
        statsInfo.columnType = baseModel.channelType;
    }
    statsInfo.tabpageId = @(tabIndex+1);
    if (subTabIndex != NSNotFound) {
        statsInfo.subTabpageId = @(subTabIndex+1);
    }
    
    statsInfo.programId = baseModel.programId;
    statsInfo.programType = baseModel.programType;
    statsInfo.programLocation = @(baseModel.programLocation+1);
    statsInfo.statsType = @(LSJStatsTypeProgramCPC);
    [self addStats:statsInfo];
    
    [MobClick event:kUmengCPCProgramEvent attributes:statsInfo.umengAttributes];
}

- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forClickCount:(NSUInteger)clickCount {
    dispatch_async(self.queue, ^{
        NSArray<LSJStatsInfo *> *statsInfos = [LSJStatsInfo statsInfosWithStatsType:LSJStatsTypeTabCPC tabIndex:tabIndex subTabIndex:subTabIndex];
        LSJStatsInfo *statsInfo = statsInfos.firstObject;
        if (!statsInfo) {
            statsInfo = [[LSJStatsInfo alloc] init];
            statsInfo.tabpageId = @(tabIndex+1);
            if (subTabIndex != NSNotFound) {
                statsInfo.subTabpageId = @(subTabIndex+1);
            }
            statsInfo.statsType = @(LSJStatsTypeTabCPC);
        }
        
        statsInfo.clickCount = @(statsInfo.clickCount.unsignedIntegerValue + clickCount);
        [statsInfo save];
        
        [MobClick event:kUmengTabEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forSlideCount:(NSUInteger)slideCount {
    dispatch_async(self.queue, ^{
        NSArray<LSJStatsInfo *> *statsInfos = [LSJStatsInfo statsInfosWithStatsType:LSJStatsTypeTabPanning tabIndex:tabIndex subTabIndex:subTabIndex];
        LSJStatsInfo *statsInfo = statsInfos.firstObject;
        if (!statsInfo) {
            statsInfo = [[LSJStatsInfo alloc] init];
            statsInfo.tabpageId = @(tabIndex+1);
            if (subTabIndex != NSNotFound) {
                statsInfo.subTabpageId = @(subTabIndex+1);
            }
            statsInfo.statsType = @(LSJStatsTypeTabPanning);
        }
        
        statsInfo.slideCount = @(statsInfo.slideCount.unsignedIntegerValue + slideCount);
        [statsInfo save];
        
        [MobClick event:kUmengTabEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)statsStopDurationAtTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex {
    dispatch_async(self.queue, ^{
        NSArray<LSJStatsInfo *> *statsInfos = [LSJStatsInfo statsInfosWithStatsType:LSJStatsTypeTabStay tabIndex:tabIndex subTabIndex:subTabIndex];
        LSJStatsInfo *statsInfo = statsInfos.firstObject;
        if (!statsInfo) {
            statsInfo = [[LSJStatsInfo alloc] init];
            statsInfo.tabpageId = @(tabIndex+1);
            if (subTabIndex != NSNotFound) {
                statsInfo.subTabpageId = @(subTabIndex+1);
            }
            statsInfo.statsType = @(LSJStatsTypeTabStay);
        }
        
        NSUInteger durationSinceStats = [[NSDate date] timeIntervalSinceDate:self.statsDate];
        statsInfo.stopDuration = @(statsInfo.stopDuration.unsignedIntegerValue + durationSinceStats);
        [statsInfo save];
        
        [self resetStatsDate];
        [MobClick event:kUmengTabEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forBanner:(NSNumber *)bannerColumnId withSlideCount:(NSUInteger)slideCount {
    dispatch_async(self.queue, ^{
        NSArray<LSJStatsInfo *> *statsInfos = [LSJStatsInfo statsInfosWithStatsType:LSJStatsTypeBannerPanning tabIndex:tabIndex subTabIndex:subTabIndex];
        LSJStatsInfo *statsInfo = statsInfos.firstObject;
        if (!statsInfo) {
            statsInfo = [[LSJStatsInfo alloc] init];
            statsInfo.tabpageId = @(tabIndex+1);
            statsInfo.statsType = @(LSJStatsTypeBannerPanning);
            statsInfo.columnId = bannerColumnId;
            if (subTabIndex != NSNotFound) {
                statsInfo.subTabpageId = @(subTabIndex+1);
            }
        }
        
        statsInfo.slideCount = @(statsInfo.slideCount.unsignedIntegerValue + slideCount);
        [statsInfo save];
        
        [MobClick event:kUmengTabEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)resetStatsDate {
    _statsDate = [NSDate date];
}

- (void)statsPayWithOrderNo:(NSString *)orderNo
                  payAction:(LSJStatsPayAction)payAction
                  payResult:(QBPayResult)payResult
               forBaseModel:(LSJBaseModel *)baseModel
                andTabIndex:(NSUInteger)tabIndex
                subTabIndex:(NSUInteger)subTabIndex
{
    dispatch_async(self.queue, ^{
        LSJStatsInfo *statsInfo = [[LSJStatsInfo alloc] init];
        statsInfo.tabpageId = @(tabIndex+1);
        if (subTabIndex != NSNotFound) {
            statsInfo.subTabpageId = @(subTabIndex+1);
        }
        statsInfo.columnId = baseModel.realColumnId;
        statsInfo.columnType = baseModel.channelType;
        statsInfo.programId = baseModel.programId;
        statsInfo.programType = baseModel.programType;
        statsInfo.programLocation = @(baseModel.programLocation+1);
        statsInfo.isPayPopup = @(1);
        statsInfo.orderNo = orderNo;
        if (payAction == LSJStatsPayActionClose) {
            statsInfo.isPayPopupClose = @(1);
        } else if (payAction == LSJStatsPayActionGoToPay) {
            statsInfo.isPayConfirm = @(1);
        } else if (payAction == LSJStatsPayActionPayBack) {
            NSDictionary *payStautsMapping = @{@(QBPayResultSuccess):@(1), @(QBPayResultFailure):@(2), @(QBPayResultCancelled):@(3)};
            NSNumber *payStatus = payStautsMapping[@(payResult)];
            statsInfo.payStatus = payStatus;
        } else {
            return ;
        }
        
        statsInfo.paySeq = @([LSJUtil launchSeq]);
        statsInfo.statsType = @(LSJStatsTypePay);
        statsInfo.network = @([QBNetworkInfo sharedInfo].networkStatus);
        [statsInfo save];
        
        [MobClick event:kUmengPayEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)statsPayWithPaymentInfo:(QBPaymentInfo *)paymentInfo
                   forPayAction:(LSJStatsPayAction)payAction
                    andTabIndex:(NSUInteger)tabIndex
                    subTabIndex:(NSUInteger)subTabIndex
{
    dispatch_async(self.queue, ^{
        LSJStatsInfo *statsInfo = [[LSJStatsInfo alloc] init];
        statsInfo.tabpageId = @(tabIndex+1);
        if (subTabIndex != NSNotFound) {
            statsInfo.subTabpageId = @(subTabIndex+1);
        }
        statsInfo.columnId = paymentInfo.columnId;
        statsInfo.columnType = paymentInfo.columnType;
        statsInfo.programId = paymentInfo.contentId;
        statsInfo.programType = paymentInfo.contentType;
        statsInfo.programLocation = paymentInfo.contentLocation;
        statsInfo.isPayPopup = @(1);
        statsInfo.orderNo = paymentInfo.orderId;
        if (payAction == LSJStatsPayActionClose) {
            statsInfo.isPayPopupClose = @(1);
        } else if (payAction == LSJStatsPayActionGoToPay) {
            statsInfo.isPayConfirm = @(1);
        } else if (payAction == LSJStatsPayActionPayBack) {
            NSDictionary *payStautsMapping = @{@(QBPayResultSuccess):@(1), @(QBPayResultFailure):@(2), @(QBPayResultCancelled):@(3)};
            NSNumber *payStatus = payStautsMapping[@(paymentInfo.paymentResult)];
            statsInfo.payStatus = payStatus;
        } else {
            return ;
        }
        
        statsInfo.paySeq = @([LSJUtil launchSeq]);
        statsInfo.statsType = @(LSJStatsTypePay);
        statsInfo.network = @([QBNetworkInfo sharedInfo].networkStatus);
        [statsInfo save];
        
        [MobClick event:kUmengPayEvent attributes:statsInfo.umengAttributes];
    });
}

@end
