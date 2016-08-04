//
//  LSJNetworkInfo.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LSJNetworkStatus) {
    LSJNetworkStatusUnknown = -1,
    LSJNetworkStatusNotReachable = 0,
    LSJNetworkStatusWiFi = 1,
    LSJNetworkStatus2G = 2,
    LSJNetworkStatus3G = 3,
    LSJNetworkStatus4G = 4
};

@interface LSJNetworkInfo : NSObject

@property (nonatomic,readonly) LSJNetworkStatus networkStatus;
@property (nonatomic,readonly) NSString *carriarName;

+ (instancetype)sharedInfo;
- (void)startMonitoring;
@end
