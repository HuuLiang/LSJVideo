//
//  LSJCPCStatsModel.h
//  LSJuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJStatsBaseModel.h"

@interface LSJCPCStatsModel : LSJStatsBaseModel

- (BOOL)statsCPCWithStatsInfos:(NSArray<LSJStatsInfo *> *)statsInfos
             completionHandler:(QBCompletionHandler)completionHandler;

@end
