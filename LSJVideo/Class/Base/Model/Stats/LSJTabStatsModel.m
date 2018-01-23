//
//  LSJTabStatsModel.m
//  LSJuaibo
//
//  Created by Sean Yue on 16/5/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJTabStatsModel.h"

@implementation LSJTabStatsModel

- (BOOL)statsTabWithStatsInfos:(NSArray<LSJStatsInfo *> *)statsInfos
             completionHandler:(QBCompletionHandler)completionHandler
{
    NSArray<NSDictionary *> *params = [self validateParamsWithStatsInfos:statsInfos];
    if (params.count == 0) {
        QBSafelyCallBlock(completionHandler,NO,@"No validated statsInfos to Commit!");
        return NO;
    }
    
    BOOL ret = [self requestURLPath:LSJ_STATS_TAB_URL
                         withParams:params
                    responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        QBSafelyCallBlock(completionHandler, respStatus == QBURLResponseSuccess, errorMessage);
    }];
    return ret;
}

@end
