//
//  LSJStatsBaseModel.h
//  LSJuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBEncryptedURLRequest.h"
#import "DBHandler.h"
typedef NS_ENUM(NSUInteger, LSJStatsType) {
    LSJStatsTypeUnknown,
    LSJStatsTypeColumnCPC,
    LSJStatsTypeProgramCPC,
    LSJStatsTypeTabCPC,
    LSJStatsTypeTabPanning,
    LSJStatsTypeTabStay,
    LSJStatsTypeBannerPanning,
    LSJStatsTypePay = 1000
};

typedef NS_ENUM(NSInteger, LSJStatsNetwork) {
    LSJStatsNetworkUnknown = 0,
    LSJStatsNetworkWifi = 1,
    LSJStatsNetwork2G = 2,
    LSJStatsNetwork3G = 3,
    LSJStatsNetwork4G = 4,
    LSJStatsNetworkOther = -1
};

@interface LSJStatsInfo : DBPersistence

// Unique ID
@property (nonatomic) NSNumber *statsId;

// System Info
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *pv;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *osv;

// Tab/Column/Program
@property (nonatomic) NSNumber *tabpageId;
@property (nonatomic) NSNumber *subTabpageId;
@property (nonatomic) NSNumber *columnId;
@property (nonatomic) NSNumber *columnType;
@property (nonatomic) NSNumber *programId;
@property (nonatomic) NSNumber *programType;
@property (nonatomic) NSNumber *programLocation;
@property (nonatomic) NSNumber *statsType; //LSJStatsType

// Accumalation stats
@property (nonatomic) NSNumber *clickCount;
@property (nonatomic) NSNumber *slideCount;
@property (nonatomic) NSNumber *stopDuration;

// Payment
@property (nonatomic) NSNumber *isPayPopup;
@property (nonatomic) NSNumber *isPayPopupClose;
@property (nonatomic) NSNumber *isPayConfirm;
@property (nonatomic) NSNumber *payStatus;
@property (nonatomic) NSNumber *paySeq;
@property (nonatomic) NSString *orderNo;
@property (nonatomic) NSNumber *network; //LSJStatsNetwork
//
+ (NSArray<LSJStatsInfo *> *)allStatsInfos;
+ (NSArray<LSJStatsInfo *> *)statsInfosWithStatsType:(LSJStatsType)statsType;
+ (NSArray<LSJStatsInfo *> *)statsInfosWithStatsType:(LSJStatsType)statsType tabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex;
+ (void)removeStatsInfos:(NSArray<LSJStatsInfo *> *)statsInfos;

- (BOOL)save;
- (BOOL)removeFromDB;
- (NSDictionary *)RESTData;
- (NSDictionary *)umengAttributes;

@end

@interface LSJStatsResponse : QBURLResponse
@property (nonatomic) NSNumber *errCode;
@end

@interface LSJStatsBaseModel : QBEncryptedURLRequest

- (NSArray<NSDictionary *> *)validateParamsWithStatsInfos:(NSArray<LSJStatsInfo *> *)statsInfos;
- (NSArray<NSDictionary *> *)validateParamsWithStatsInfos:(NSArray<LSJStatsInfo *> *)statsInfos shouldIncludeStatsType:(BOOL)includeStatsType;

@end
