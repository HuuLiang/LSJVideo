//
//  LSJPayStatsModel.m
//  LSJuaibo
//
//  Created by Sean Yue on 16/5/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJPayStatsModel.h"

@implementation LSJPayStatsModel

- (BOOL)statsPayWithStatsInfos:(NSArray<LSJStatsInfo *> *)statsInfos completionHandler:(QBCompletionHandler)completionHandler {
    NSArray<NSDictionary *> *params = [self validateParamsWithStatsInfos:statsInfos shouldIncludeStatsType:NO];
    if (params.count == 0) {
        QBSafelyCallBlock(completionHandler,NO,@"No validated statsInfos to Commit!");
        return NO;
    }
    
    BOOL ret = [self requestURLPath:LSJ_STATS_PAY_URL
                         withParams:params
                    responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        QBSafelyCallBlock(completionHandler, respStatus==QBURLResponseSuccess, errorMessage);
    }];
    return ret;
}

@end
