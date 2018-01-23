//
//  LSJStatsManager.h
//  LSJuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSJBaseModel.h"

typedef NS_ENUM(NSUInteger, LSJStatsPayAction) {
    LSJStatsPayActionUnknown,
    LSJStatsPayActionClose,
    LSJStatsPayActionGoToPay,
    LSJStatsPayActionPayBack
};

@class LSJStatsInfo;
@class LSJChannel;
@interface LSJStatsManager : NSObject

+ (instancetype)sharedManager;

- (void)addStats:(LSJStatsInfo *)statsInfo;
- (void)removeStats:(NSArray<LSJStatsInfo *> *)statsInfos;
- (void)scheduleStatsUploadWithTimeInterval:(NSTimeInterval)timeInterval;

// Helper Methods
- (void)statsCPCWithBaseModel:(LSJBaseModel *)baseModel inTabIndex:(NSUInteger)tabIndex;
- (void)statsCPCWithBaseModel:(LSJBaseModel *)baseModel
                  andTabIndex:(NSUInteger)tabIndex
                  subTabIndex:(NSUInteger)subTabIndex;

- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forClickCount:(NSUInteger)clickCount;
- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forSlideCount:(NSUInteger)slideCount;
- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forBanner:(NSNumber *)bannerColumnId withSlideCount:(NSUInteger)slideCount;
- (void)statsStopDurationAtTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex;

- (void)statsPayWithOrderNo:(NSString *)orderNo
                  payAction:(LSJStatsPayAction)payAction
                  payResult:(QBPayResult)payResult
               forBaseModel:(LSJBaseModel *)baseModel
                andTabIndex:(NSUInteger)tabIndex
                subTabIndex:(NSUInteger)subTabIndex;

- (void)statsPayWithPaymentInfo:(QBPaymentInfo *)paymentInfo
                   forPayAction:(LSJStatsPayAction)payAction
                    andTabIndex:(NSUInteger)tabIndex
                    subTabIndex:(NSUInteger)subTabIndex;

@end
