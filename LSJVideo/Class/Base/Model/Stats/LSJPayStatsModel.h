//
//  LSJPayStatsModel.h
//  LSJuaibo
//
//  Created by Sean Yue on 16/5/3.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "LSJStatsBaseModel.h"

@interface LSJPayStatsModel : LSJStatsBaseModel

- (BOOL)statsPayWithStatsInfos:(NSArray<LSJStatsInfo *> *)statsInfos completionHandler:(QBCompletionHandler)completionHandler;

@end
